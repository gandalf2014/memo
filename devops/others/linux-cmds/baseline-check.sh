#!/bin/bash
#read key
echo "警告：本脚本只是一个检查的操作，未对服务器做任何修改，管理员可以根据此报告进行相应的设置。"
if [[ "$EUID" -ne 0 ]]; then 
		echo "请以root身份运行基线检查" 
		exit 1
fi 
#
user_id=`whoami`
echo "当前扫描用户：$user_id"

scanner_time=`date "+%Y-%m-%d %H:%M:%S"`
echo "当前扫描时间：${scanner_time}"
echo -------------------------------------------------------------------------
echo ---------------------------------------主机安全检查-----------------------
echo "系统版本"
uname -a
echo --------------------------------------------------------------------------
echo "本机的ip地址是："
#ifconfig | grep --color "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}"
hostname -I
echo ------------------------扫描禁止root远程登陆--------------------------------
if more /etc/ssh/sshd_config | grep "^PermitRootLogin"; then
    more /etc/ssh/sshd_config | grep "PermitRootLogin" | tr -s " " | awk '{if($2="yes"){print "未禁用root远程登陆"}else{print "已禁用root远程登陆"}}'
else
    echo "已禁用root远程登陆"
fi
echo ---------------------------------------扫描系统空账户-----------------------
awk -F":" '($2 == "!!" || $2 == "*") {print "账户"$1"是空账户,请管理员检查是否需要锁定或者删除它"}' /etc/shadow
#normal_usr_accounts=`eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1`

#echo "普通账号扫描结果:$normal_usr_accounts"
# 空密码的账户
# empty_pass_usrs=`awk -F":" '($2 == "!!" || $2 == "*") {print $1}' /etc/shadow`
# echo "空密码账户扫描结果:$empty_pass_usrs"
# #删除空密码的普通账号
# for usr in $normal_usr_accounts
# do
#     for empty_usr in $empty_pass_usrs
#     do
#         if [ "$usr"="$empty_usr" ]
#         then
#             echo "${usr}是空密码普通账户,请管理员检查是否需要锁定或者删除它"
#             #userdel -r $usr
#         fi
#     done
# done

echo --------------------------------------------------------------------------
awk -F":" '{if($2!~/^!|^*/){print "("$1")" " 是一个未被锁定的账户，请管理员检查是否需要锁定它或者删除它。"}}' /etc/shadow
echo ----------------------------扫描密码强度策略--------------------------------
# more /etc/pam.d/system-auth | grep "minlen" | tr " " "\n" | grep minlen | awk -F '=' '{if($2<16){print "/etc/pam.d/system-auth里边的minlen设置的是"$2" 未满足最小密码长度16"}}'
# more /etc/pam.d/system-auth | grep -E "lcredit=-1" -o | awk  '{print "密码策略启用小写字母"}'
# more /etc/pam.d/system-auth | grep -E "ucredit=-1" -o | awk '{print "密码策略启用大写字母"}'
# more /etc/pam.d/system-auth | grep -E "dcredit=-1" -o | awk '{print "密码策略启用数字"}'
# more /etc/pam.d/system-auth | grep -E "ocredit=-1" -o | awk '{print "密码策略启用特殊字符"}'
# more /etc/pam.d/system-auth | grep -E "remember=6" -o | awk '{print "不能重复使用最近6次的密码"}'
# authconfig --test | grep -E "pam_pwquality"
# echo "请检查最小密码长度是否满足"
if grep "^minlen" /etc/security/pwquality.conf ;then 
grep "^minlen" /etc/security/pwquality.conf | tr -d " " | awk -F= '($2<16){print "密码长度未满足要求"}'
else
echo "未指定密码策略：密码长度至少16位"
fi

if grep "^lcredit" /etc/security/pwquality.conf; then
grep "^lcredit" /etc/security/pwquality.conf | tr -d " " |  awk -F= '{if($2!=-1){print "密码策略未启用小写字母"}else{print "密码策略已启用小写字母"}}'
else
echo "未指定密码策略：至少需要一个小写字母"
fi

if grep "^ucredit" /etc/security/pwquality.conf;then
grep "^ucredit" /etc/security/pwquality.conf | tr -d " " |  awk -F= '{if($2!=-1){print "密码策略未启用大写字母"}else{print "密码策略启用大写字母"}}'
else 
echo "未指定密码策略：至少需要一个大写字母"
fi

if grep "^dcredit" /etc/security/pwquality.conf; then
grep "^dcredit" /etc/security/pwquality.conf | tr -d " " |  awk -F= '{if($2!=-1){print "密码策略未启用数字"}else{print "密码策略启用数字"}}'
else
echo "未指定密码策略：至少需要一个数字"
fi

if grep "^ocredit" /etc/security/pwquality.conf ;then
grep "^ocredit" /etc/security/pwquality.conf  | tr -d " " |  awk -F= '{if($2!=-1){print "密码策略未启用特殊字符"}else{print "密码策略已启用特殊字符"}}'
else
echo "未指定密码策略：至少需要一个特殊字符"
fi

if grep  '^difok' /etc/security/pwquality.conf ; then
grep  '^difok' /etc/security/pwquality.conf | tr -d " " |  awk -F= '{if($2>=6){print "不能重复使用最近$2次的密码满足要求"}else{print "不能重复最近6次使用过的密码"}}'
else
echo "未指定密码策略：不能使用最近6次使用过的密码"
fi
echo ----------------------------扫描特定的IP连接SSH-----------------------------
if more  /etc/ssh/sshd_config | grep AllowUsers ; then
more  /etc/ssh/sshd_config | grep AllowUsers | tr " " "\n" | awk  '(NR!=1){print  "地址" $1}'
else
echo "未限定IP访问SSH"
fi
echo ----------------------------扫描用户登录失败次数大于3次锁定账户-----------------
if more /etc/pam.d/password-auth | grep deny=3 ; then
echo "已开启登录失败次数限制"
else
echo "未开启登录失败次数限制"
fi
echo ----------------------------扫描普通用户使用sudo--------------


echo ----------------------------扫描hosts文件权限-----------------
stat -c '%a' /etc/hosts | awk '{if($1==644){print "hosts文件权限644"}else{print "hosts文件权限不是644"}}'

echo ----------------------------扫描SSH登录隐藏Banner-----------------
if more /etc/ssh/sshd_config | grep "^Banner none" > /dev/null 2>&1 ; then
    echo "SSH登录，Banner已隐藏"
else
    echo "未隐藏SSH登录Banner"
fi
echo ----------------------------扫描指令别名-----------------
alias
echo ----------------------------扫描禁止使用命令-----------------
if rpm -qa | grep wget ; then
echo "wget 命令未被禁止" 
else
echo "wget 命令未安装" 
fi

if rpm -qa | grep nmap ; then
echo "nmap 命令未被禁止" 
else
echo "nmap 命令未安装" 
fi


if rpm -qa | grep telnet ; then
echo "telnet 命令未被禁止" 
else
echo "telnet 命令未安装" 
fi


if rpm -qa | grep netcat ; then
echo "nc(netcat) 命令未被禁止" 
else
echo "nc(netcat) 命令未安装" 
fi
echo ----------------------------扫描常用命令是否缺失-----------------
if which curl > /dev/null 2>&1 ; then
echo "curl 命令存在" 
else
echo "curl 命令缺失" 
fi

if which netstat > /dev/null 2>&1 ; then
echo "netstat 命令存在" 
else
echo "netstat 命令缺失" 
fi


if which ping  > /dev/null 2>&1 ; then
echo "ping 命令存在" 
else
echo "ping 命令缺失" 
fi

if which ss > /dev/null 2>&1 ; then
echo "ss 命令存在" 
else
echo "ss 命令缺失" 
fi

if which find > /dev/null 2>&1 ; then
echo "find 命令存在" 
else
echo "find 命令缺失" 
fi

if which lftp > /dev/null 2>&1 ; then
echo "lftp 命令存在" 
else
echo "lftp 命令缺失" 
fi


if which history > /dev/null 2>&1 ; then
echo "history 命令存在" 
else
echo "history 命令缺失" 
fi

echo --------------------------------------------------------------------------
more /etc/login.defs | grep -E "PASS_MAX_DAYS" | grep -v "#" |awk -F' '  '{if($2!=90){print "/etc/login.defs里面的"$1 "设置的是"$2"天，请管理员改成90天。"}}'
echo --------------------------------------------------------------------------
more /etc/login.defs | grep -E "PASS_MIN_LEN" | grep -v "#" |awk -F' '  '{if($2!=16){print "/etc/login.defs里面的"$1 "设置的是"$2"个字符，请管理员改成16个字符。"}}'
echo --------------------------------------------------------------------------
more /etc/login.defs | grep -E "PASS_WARN_AGE" | grep -v "#" |awk -F' '  '{if($2!=10){print "/etc/login.defs里面的"$1 "设置的是"$2"天，请管理员将口令到期警告天数改成10天。"}}'
echo --------------------------------------------------------------------------
grep TMOUT /etc/profile /etc/bashrc > /dev/null|| echo "未设置登录超时限制，请设置之，设置方法：在/etc/profile或者/etc/bashrc里面添加TMOUT=600参数"
echo --------------------------------------------------------------------------
if ps -elf |grep xinet |grep -v "grep xinet";then
echo "xinetd 服务正在运行，请检查是否可以把xinnetd服务关闭"
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
echo "SSH服务未开启"
fi
echo --------------------------------------------------------------------------
echo "查看是否开启了TELNET服务"
if more /etc/xinetd.d/telnetd 2>&1|grep -E "disable=no"; then
echo  "TELNET服务已开启 "
else
echo  "TELNET服务未开启 "
fi
echo --------------------------------------------------------------------------
echo  "查看系统SSH远程访问设置策略(host.deny拒绝列表)"
if more /etc/hosts.deny | grep -E "sshd: ";more /etc/hosts.deny | grep -E "sshd"; then
echo  "远程访问策略已设置 "
else
echo  "远程访问策略未设置 "
fi
echo --------------------------------------------------------------------------
echo  "查看系统SSH远程访问设置策略(hosts.allow允许列表)"
if more /etc/hosts.allow | grep -E "sshd: ";more /etc/hosts.allow | grep -E "sshd"; then
echo  "远程访问策略已设置 "
else
echo  "远程访问策略未设置 "
fi
echo "当hosts.allow和 host.deny相冲突时，以hosts.allow设置为准。"
echo -------------------------------------------------------------------------
echo "查看shell是否设置超时锁定策略"
if more /etc/profile | grep -E "TIMEOUT= "; then
echo  "系统设置了超时锁定策略 "
else
echo  "未设置超时锁定策略 "
fi
echo -------------------------------------------------------------------------
echo "查看syslog日志审计服务是否开启"
if service syslog status | egrep " active \(running";then
echo "syslog服务已开启"
else
echo "syslog服务未开启，建议通过service syslog start开启日志审计功能"
fi
echo -------------------------------------------------------------------------
echo "查看syslog日志是否开启外发"
if more /etc/rsyslog.conf | egrep "@...\.|@..\.|@.\.|\*.\* @...\.|\*\.\* @..\.|\*\.\* @.\.";then
echo "客户端syslog日志已开启外发"
else
echo "客户端syslog日志未开启外发"
fi
echo -------------------------------------------------------------------------
echo "查看passwd文件中有哪些特权用户"
awk -F: '$3==0 {print $1}' /etc/passwd
echo ------------------------------------------------------------------------
echo "查看系统中是否存在空口令账户"
awk -F: '($2=="!!") {print $1}' /etc/shadow
echo "该结果不适用于Ubuntu系统"
echo ------------------------------------------------------------------------
echo "查看系统中root用户外连情况"
lsof -u root |egrep "ESTABLISHED|SYN_SENT|LISTENING"
echo ----------------------------状态解释------------------------------
echo "ESTABLISHED的意思是建立连接。表示两台机器正在通信。"
echo "LISTENING的"
echo "SYN_SENT状态表示请求连接"
echo ------------------------------------------------------------------------
echo "查看系统中root用户TCP连接情况"
lsof -u root |egrep "TCP"
echo ------------------------------------------------------------------------
echo "查看系统中存在哪些非系统默认用户"
echo "user:x:“该值大于500为新创建用户，小于或等于500为系统初始用户”"
more /etc/passwd |awk -F ":" '{if($3>500){print "/etc/passwd里面的"$1 "的值为"$3"，请管理员确认该账户是否正常。"}}'
echo ------------------------------------------------------------------------
echo "检查系统守护进程"
more /etc/xinetd.d/rsync | grep -v "^#"
echo ------------------------------------------------------------------------
echo "检查系统是否存在入侵行为"
more /var/log/secure |grep refused
echo ------------------------------------------------------------------------
echo "-----------------------检查系统是否存在PHP脚本后门---------------------"
if find / -type f -name *.php | xargs egrep -l "mysql_query\($query, $dbconn\)|专用网马|udf.dll|class PHPzip\{|ZIP压缩程序 荒野无灯修改版|$writabledb|AnonymousUserName|eval\(|Root_CSS\(\)|黑狼PHP木马|eval\(gzuncompress\(base64_decode|if\(empty\($_SESSION|$shellname|$work_dir |PHP木马|Array\("$filename"| eval\($_POST\[|class packdir|disk_total_space|wscript.shell|cmd.exe|shell.application|documents and settings|system32|serv-u|提权|phpspy|后门" |sort -n|uniq -c |sort -rn 1>/dev/null 2>&1;then
echo "检测到PHP脚本后门"
find / -type f -name *.php | xargs egrep -l "mysql_query\($query, $dbconn\)|专用网马|udf.dll|class PHPzip\{|ZIP压缩程序 荒野无灯修改版|$writabledb|AnonymousUserName|eval\(|Root_CSS\(\)|黑狼PHP木马|eval\(gzuncompress\(base64_decode|if\(empty\($_SESSION|$shellname|$work_dir |PHP木马|Array\("$filename"| eval\($_POST\[|class packdir|disk_total_space|wscript.shell|cmd.exe|shell.application|documents and settings|system32|serv-u|提权|phpspy|后门" |sort -n|uniq -c |sort -rn
find / -type f -name *.php | xargs egrep -l "mysql_query\($query, $dbconn\)|专用网马|udf.dll|class PHPzip\{|ZIP压缩程序 荒野无灯修改版|$writabledb|AnonymousUserName|eval\(|Root_CSS\(\)|黑狼PHP木马|eval\(gzuncompress\(base64_decode|if\(empty\($_SESSION|$shellname|$work_dir |PHP木马|Array\("$filename"| eval\($_POST\[|class packdir|disk_total_space|wscript.shell|cmd.exe|shell.application|documents and settings|system32|serv-u|提权|phpspy|后门" |sort -n|uniq -c |sort -rn |awk '{print $2}' | xargs -I{} cp {} /tmp/
echo "后门样本已拷贝到/tmp/目录"
else
echo "未检测到PHP脚本后门"
fi
echo ------------------------------------------------------------------------
echo "-----------------------检查系统是否存在JSP脚本后门---------------------"
find / -type f -name *.jsp | xargs egrep -l "InputStreamReader\(this.is\)|W_SESSION_ATTRIBUTE|strFileManag|getHostAddress|wscript.shell|gethostbyname|cmd.exe|documents and settings|system32|serv-u|提权|jspspy|后门" >/dev/null 2>&1  |sort -n|uniq -c |sort -rn 2>&1
find / -type f -name *.jsp | xargs egrep -l "InputStreamReader\(this.is\)|W_SESSION_ATTRIBUTE|strFileManag|getHostAddress|wscript.shell|gethostbyname|cmd.exe|documents and settings|system32|serv-u|提权|jspspy|后门" >/dev/null 2>&1  |sort -n|uniq -c |sort -rn| awk '{print $2}' | xargs -I{} cp {} /tmp/  2>&1 
echo ------------------------------------------------------------------------
echo "----------------------检查系统是否存在HTML恶意代码---------------------"
if find / -type f -name *.html | xargs egrep -l "WriteData|svchost.exe|DropPath|wsh.Run|WindowBomb|a1.createInstance|CurrentVersion|myEncString|DropFileName|a = prototype;|204.351.440.495.232.315.444.550.64.330" 1>/dev/null 2>&1;then
echo "发现HTML恶意代码"
find / -type f -name *.html | xargs egrep -l "WriteData|svchost.exe|DropPath|wsh.Run|WindowBomb|a1.createInstance|CurrentVersion|myEncString|DropFileName|a = prototype;|204.351.440.495.232.315.444.550.64.330" |sort -n|uniq -c |sort -rn
find / -type f -name *.html | xargs egrep -l "WriteData|svchost.exe|DropPath|wsh.Run|WindowBomb|a1.createInstance|CurrentVersion|myEncString|DropFileName|a = prototype;|204.351.440.495.232.315.444.550.64.330" |sort -n|uniq -c |sort -rn| awk '{print $2}' | xargs -I{} cp {} /tmp/
echo "后门样本已拷贝到/tmp/目录"
else
echo "未检测到HTML恶意代码"
fi
echo "----------------------检查系统是否存在perl恶意程序----------------------"
if find / -type f -name *.pl | xargs egrep -l "SHELLPASSWORD|shcmd|backdoor|setsockopt|IO::Socket::INET;" 1>/dev/null 2>&1;then
echo "发现perl恶意程序"
find / -type f -name *.pl | xargs egrep -l "SHELLPASSWORD|shcmd|backdoor|setsockopt|IO::Socket::INET;"|sort -n|uniq -c |sort -rn
find / -type f -name *.pl | xargs egrep -l "SHELLPASSWORD|shcmd|backdoor|setsockopt|IO::Socket::INET;"|sort -n|uniq -c |sort -rn| awk '{print $2}' | xargs -I{} cp {} /tmp/
echo "可疑样本已拷贝到/tmp/目录"
else
echo "未检测到perl恶意程序"
fi
echo "----------------------检查系统是否存在Python恶意程序----------------------"
find / -type f -name *.py | xargs egrep -l "execCmd|cat /etc/issue|getAppProc|exploitdb" >/dev/null 2>&1 |sort -n|uniq -c |sort -rn
find / -type f -name *.py | xargs egrep -l "execCmd|cat /etc/issue|getAppProc|exploitdb" >/dev/null 2>&1 |sort -n|uniq -c |sort -rn| awk '{print $2}' | xargs -I{} cp {} /tmp/
echo ------------------------------------------------------------------------
echo "-----------------------检查系统是否存在恶意程序---------------------"
find / -type f -perm -111  |xargs egrep "UpdateProcessER12CUpdateGatesE6C|CmdMsg\.cpp|MiniHttpHelper.cpp|y4'r3 1uCky k1d\!|execve@@GLIBC_2.0|initfini.c|ptmalloc_unlock_all2|_IO_wide_data_2|system@@GLIBC_2.0|socket@@GLIBC_2.0|gettimeofday@@GLIBC_2.0|execl@@GLIBC_2.2.5|WwW.SoQoR.NeT|2.6.17-2.6.24.1.c|Local Root Exploit|close@@GLIBC_2.0|syscall\(\__NR\_vmsplice,|Linux vmsplice Local Root Exploit|It looks like the exploit failed|getting root shell" 2>/dev/null
echo ------------------------------------------------------------------------
echo "检查网络连接和监听端口"
if which netstat ; then 
netstat -an 
else
sudo lsof -i -P -n
fi
echo "--------------------------路由表、网络连接、接口信息--------------"
if which netstat ; then
netstat -rn 
elif which route ; then
route -n 
else
ip a s 
fi
echo "------------------------查看网卡详细信息--------------------------"
if which ifconfig; then 
ifconfig -a 
else
ip link
fi
echo ------------------------------------------------------------------------
echo "查看正常情况下登录到本机的所有用户的历史记录"
last
echo ------------------------------------------------------------------------
echo "检查系统中core文件是否开启"
ulimit -c
echo "core是unix系统的内核。当你的程序出现内存越界的时候,操作系统会中止你的进程,并将当前内存状态倒出到core文件中,以便进一步分析，如果返回结果为0，则是关闭了此功能，系统不会生成core文件"
echo ------------------------------------------------------------------------
echo "检查系统中关键文件修改时间"
ls -ltr /bin/ls /bin/login /etc/passwd /bin/ps /usr/bin/top /etc/shadow |tr -s " "| tr " " "%" | awk -F% '{print "文件名" $9 "最后修改时间：" $7 " " $8}'
echo "ls文件：是存储ls命令的功能函数，被删除以后，就无法执行ls命令，黑客可利用篡改ls文件来执行后门或其他程序。
login文件：login是控制用户登录的文件，一旦被篡改或删除，系统将无法切换用户或登陆用户
user/bin/passwd是一个命令，可以为用户添加、更改密码，但是，用户的密码并不保存在/etc/passwd当中，而是保存在了/etc/shadow当中
etc/passwd是一个文件，主要是保存用户信息。
sbin/portmap是文件转换服务，缺少该文件后，无法使用磁盘挂载、转换类型等功能。
bin/ps 进程查看命令功能支持文件，文件损坏或被更改后，无法正常使用ps命令。
usr/bin/top  top命令支持文件，是Linux下常用的性能分析工具,能够实时显示系统中各个进程的资源占用状况。
etc/shadow shadow 是 /etc/passwd 的影子文件，密码存放在该文件当中，并且只有root用户可读。"
echo --------------------------------------------------------------------------
echo "-------------------查看系统日志文件是否存在--------------------"
log=/var/log/syslog
log2=/var/log/messages
if [ -e "$log" ]; then
echo  "syslog日志文件存在！ "
else
echo  "/var/log/syslog日志文件不存在！ "
fi
if [ -e "$log2" ]; then
echo  "/var/log/messages日志文件存在！ "
else
echo  "/var/log/messages日志文件不存在！ "
fi
echo --------------------------------------------------------------------------
echo "检查系统文件完整性2(MD5检查)"
echo "该项会获取部分关键文件的MD5值并入库，默认保存在/etc/md5db中"
echo "如果第一次执行，则会提示md5sum: /sbin/portmap: 没有那个文件或目录"
echo "第二次重复检查时，则会对MD5DB中的MD5值进行匹配，来判断文件是否被更改过"
file="/etc/md5db"
if [ -e "$file" ]; then md5sum -c /etc/md5db 2>&1; 
else 
md5sum /etc/passwd >>/etc/md5db
md5sum /etc/shadow >>/etc/md5db
md5sum /etc/group >>/etc/md5db
md5sum /usr/bin/passwd >>/etc/md5db
md5sum /sbin/portmap>>/etc/md5db
md5sum /bin/login >>/etc/md5db
md5sum /bin/ls >>/etc/md5db
md5sum /bin/ps >>/etc/md5db
md5sum /usr/bin/top >>/etc/md5db;
fi
echo ----------------------------------------------------------------------
echo "------------------------主机性能检查--------------------------------"
echo "CPU检查"
dmesg | grep -i cpu
echo -----------------------------------------------------------------------
more /proc/cpuinfo
echo -----------------------------------------------------------------------
echo "内存状态检查"
vmstat 2 5
echo -----------------------------------------------------------------------
more /proc/meminfo
echo -----------------------------------------------------------------------
free -m
echo -----------------------------------------------------------------------
echo "文件系统使用情况"
df -h
echo -----------------------------------------------------------------------
echo "网卡使用情况"
lspci -tv
echo ----------------------------------------------------------------------
echo "查看僵尸进程"
ps -ef | grep zombie
echo ----------------------------------------------------------------------
echo "耗CPU最多的进程"
ps auxf |sort -nr -k 3 |head -5
echo ----------------------------------------------------------------------
echo "耗内存最多的进程"
ps auxf |sort -nr -k 4 |head -5
echo ----------------------------------------------------------------------