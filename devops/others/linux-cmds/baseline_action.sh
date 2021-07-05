#!/bin/sh
#set -Eeuxo pipefail
#系统账号
# 1)删除空密码的账号
# 2)删除或锁定非（系统与服务）帐户
# 3)按照使用部门分配账号
# 4)只允许特定ip发起SSH连接（ansible等）
# 5)配置当用户连续认证失败次数超过3次（含3次），锁定该用户使用的账号（普通用户锁定时间：60s）
# 6)密码策略（16位、包含数字、大小字母、特殊字符）
# 7)不能重复使用最近6次（含6次）内已使用的口令
# 8)普通机器禁止普通账号（操作用户和只读用户）使用sudo –i,除运维外研发、测试有需求需提邮件或者oa流程
# 9)配置允许已知系统账号列表

if [[ "$EUID" -ne 0 ]]; then 
		echo "请以root身份运行基线检查" 
		exit 1
fi 


#
user_id=$(whoami)
echo ="当前扫描用户：${user_id}"

scanner_time=$(date '+%F %T')
echo "当前扫描时间：${scanner_time}"

echo -----------------------------开始备份文件------------------------------------------
cp /etc/login.defs /etc/login.defs.bak
cp /etc/security/limits.conf /etc/security/limits.conf.bak
cp /etc/pam.d/su  /etc/pam.d/su.bak
cp /etc/profile /etc/profile.bak
cp /etc/issue.net /etc/issue.net.bak
cp /etc/shadow /etc/shadow.bak
cp /etc/passwd /etc/passwd.bak
cp /etc/pam.d/passwd  /etc/pam.d/passwd.bak
cp /etc/host.conf /etc/host.conf.bak
cp /etc/hosts.allow /etc/hosts.allow.bak
cp -p /etc/sysctl.conf /etc/sysctl.conf.bak
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cp /etc/profile /etc/profile.bak
cp /etc/security/pwquality.conf /etc/security/pwquality.conf.bak
echo -----------------------------备份文件结束-------------------------------------------
echo -------------------锁定普通账号,zdsoft,zdsoftro账号不锁------------------------------
normal_usr_accounts=($(awk -F":" '{if($2!~/^!|^*/){printf $1" " }}' /etc/shadow))
for usr in "${normal_usr_accounts[@]}"
do
    if [ "$usr" != "zdsoft" -a "$usr" != "zdsoftro" -a "$usr" != "vagrant" ] ; then
            echo "锁定普通账户$usr"
            #passwd -l $usr ; chage -E0 $usr ; usermod -s /sbin/nologin $usr
            #passwd -u $usr; chage -E $(date -d +180days +%Y-%m-%d) $usr; usermod -s  /bin/bash $usr
    fi
done

echo ----------------------------扫描密码强度策略----------------------------------------
echo "密码长度最短16位，必须至少包含1一个小写字母，一个大写字母，一个数字，一个特殊字符，相同类型的字符不得重复10次"
authconfig --passalgo=sha512 --passminlen=16 --passminclass=3 --passmaxrepeat=5 --passmaxclassrepeat=10 \
 --enablereqlower --enablerequpper --enablereqdigit --enablereqother --enablefaillock \
 --faillockargs="deny=3 even_deny_root unlock_time=60" --update
echo ----------------------------------------------------------------------------------
if grep  '^difok' /etc/security/pwquality.conf &>/dev/null; then
grep  '^difok' /etc/security/pwquality.conf | tr -d " " |  awk -F= '{if($2>=6){print "不能重复使用最近$2次的密码满足要求"}else{print "不能重复最近6次使用过的密码"}}'
else
echo "difok   = 6" >> /etc/security/pwquality.conf
fi
echo --------------------------------账户密码定期修改策略-------------------------------
sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS  90/" /etc/login.defs
sed -i "s/^PASS_MIN_LEN.*/PASS_MIN_LEN  16/" /etc/login.defs
sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE  10/" /etc/login.defs
echo ----------------------------------设置SSH会话超时10min-----------------------------
if grep TMOUT /etc/profile /etc/bashrc > /dev/null; then
echo "已启用SSH会话超时"
else
echo -e "TMOUT=300\nreadonly TMOUT\nexport TMOUT" >> /etc/profile
fi
echo ----------------------------扫描特定的IP连接SSH-------------------------------------
if more  /etc/ssh/sshd_config | grep AllowUsers ; then
more  /etc/ssh/sshd_config | grep AllowUsers | tr " " "\n" | awk  '(NR!=1){print  "地址" $1}'
else
echo "未限定IP访问SSH"
fi
echo ------------------------禁止root远程登陆---------------------------------------------
if more /etc/ssh/sshd_config | grep "^PermitRootLogin"; then
    sed -i "s/^PermitRootLogin.*/PermitRootLogin  no/" /etc/ssh/sshd_config
else
    echo "PermitRootLogin  no" >> /etc/ssh/sshd_config
    systemctl restart sshd
fi
echo ----------------------------扫描用户登录失败次数大于3次锁定账户--------------------------
if more /etc/pam.d/password-auth | grep deny=3 ; then
echo "已开启登录失败次数限制"
else
authconfig  --faillockargs="deny=3 even_deny_root unlock_time=60" --update
fi
echo ----------------------------扫描普通用户使用sudoers-------------------------------------
more /etc/sudoers | grep -v  "^#" | grep -v  "^Default" | awk NF
echo ----------------------------扫描hosts文件权限-------------------------------------------
stat -c '%a' /etc/hosts | awk '{if($1==644){print "hosts文件权限644"}else{print "hosts文件权限不是644"}}'
ls -al /etc/hosts
echo ----------------------------扫描SSH登录隐藏Banner---------------------------------------
if more /etc/ssh/sshd_config | grep "^Banner none" > /dev/null 2>&1 ; then
    echo "SSH登录，Banner已隐藏"
else
    echo "Banner none" >> /etc/ssh/sshd_config
    systemctl restart sshd
fi
echo ----------------------------扫描禁止使用命令-----------------------------
disabled_cmds=(wget nmap telnet netcat)
for cmd in ${disabled_cmds[@]}
do
    if which ${cmd} &> /dev/null; then
    rpm -e ${cmd} &> /dev/null
    else
    echo "${cmd} 命令已禁用" 
    fi
done
echo ----------------------------扫描常用命令是否缺失-----------------
required_cmds=(curl netstat ping ss find lftp)
for cmd in ${required_cmds[@]}
do
    if which ${cmd} &> /dev/null; then
    echo "${cmd} 命令存在" 
    else
    echo "${cmd} 命令缺失" 
    fi
done

echo --------------------------------------------------------------------------
if ps -elf |grep xinet |grep -v "grep xinet";then
systemctl stop xinetd
else
echo "xinetd 服务未开启"
fi
echo --------------------------------------------------------------------------
echo "查看系统密码文件修改时间"
ls -ltr /etc/passwd
echo --------------------------------------------------------------------------
echo  "查看是否开启了ssh服务"
if service sshd status | grep -E "listening on|active \(running\)"; then
echo "SSH服务已开启"
else
systemctl start sshd
fi
echo --------------------------------------------------------------------------
