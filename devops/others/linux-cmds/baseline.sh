#!/bin/sh

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
user_id=whoami
echo ="当前扫描用户：${user_id}"

scanner_time=date '+%Y-%m-%d %H:%M:%S'
echo "当前扫描时间：${scanner_time}"
echo "***************************"
echo "账号策略检查中…"
echo "***************************"


# 扫描系统普通账号
echo "扫描系统普通账号..."

normal_usr_accounts=`eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1`

echo "普通账号扫描结果:$normal_usr_accounts"

# 空密码的账户
empty_pass_usrs=`awk -F":" '($2 == "!!" || $2 == "*") {print $1}' /etc/shadow`
echo "空密码账户扫描结果:$empty_pass_usrs"
#删除空密码的普通账号
for usr in $normal_usr_accounts
do
    for empty_usr in $empty_pass_usrs
    do
        if [ "$usr"="$empty_usr" ]
        then
            echo "删除空密码普通账户$usr"
            userdel -r $usr
        fi
    done
done

#锁定普通账号,待商讨dev权限
for usr in $normal_usr_accounts
do
    echo "锁定普通账户$usr"
    #passwd -l $usr ; chage -E0 $usr ; usermod -s /sbin/nologin $usr
done


#按照使用部门分配账号
create_user_for_department(){
    read -p "请输入部门名称简写单词" dept_name
    read -p "请输入账号用途简写单词" desc_name
    useradd -m "${dept_name}_${desc_name}" 
    
}
#配置当用户连续认证失败次数超过3次（含3次），锁定该用户使用的账号（普通用户锁定时间：60s）

# 备份 authconfig --savebackup=20210628    备份路径  /var/lib/authconfig/backup-20210628/
# 恢复 authconfig --restorebackup=20210628
# 恢复上一次备份 authconfig --restorelastbackup
# 启用本地授权 authconfig --enablelocauthorize --enablepamaccess --update
# 这将最小长度设置为 9 个字符，不允许字符或类重复两次以上，并且需要大写和特殊字符
# authconfig --passminlen=9 --passminclass=3 --passmaxrepeat=2 -passmaxclassrepeat=2 --enablerequpper --enablereqother --update
# centos7
vi /etc/pam.d/system-auth
password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type= minlen=16 lcredit=-1 ucredit=-1 dcredit=-1 ocredi
t=-1 enforce_for_root

echo "扫描密码强度策略"
echo "密码长度"


# ubuntu /etc/pam.d/common-password


#不能重复最近6次的密码
vi /etc/pam.d/system-auth
password  sufficient  pam_unix.so md5 shadow nullok try_first_pass use_authtok remember=6

#IP 协议

#1)禁止telnet远程登录
#2)隐藏ssh的banner信息



#配置管理

#禁止（普通用户）修改hosts文件