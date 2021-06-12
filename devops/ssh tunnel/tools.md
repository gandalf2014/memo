## pssh
### Examples
- Connect to host1 and host2, and print "hello, world" from each:
`pssh -i -H "host1 host2" echo "hello, world"`
- Print "hello, world" from each host specified in the file hosts.txt:
`pssh -i -h hosts.txt echo "hello, world"`
- Run a command as root with a prompt for the root password:
`pssh -i -h hosts.txt -A -l root echo hi`
- Run a long command without timing out:
`pssh -i -h hosts.txt -t 0 sleep 10000`
- If the file hosts.txt has a large number of entries, say 100, then the parallelism option may also be set to 100 to ensure that the commands are run concurrently:
`pssh -i -h hosts.txt -p 100 -t 0 sleep 10000`
- Run a command without checking or saving host keys:
`pssh -i -H host1 -H host2 -x "-O StrictHostKeyChecking=no -O UserKnownHostsFile=/dev/null -O GlobalKnownHostsFile=/dev/null" echo hi`
- Print the node number for each connection (this will print 0, 1, and 2):
`pssh -i -H host1 -H host1 -H host2 'echo $PSSH_NODENUM'`

## sshpass
How do I use sshpass in Linux or Unix?
Login to ssh server called server.example.com with password called t@uyM59bQ:
`$ sshpass -p 't@uyM59bQ' ssh username@server.example.com`

For shell script you may need to disable host key checking:
`$ sshpass -p 't@uyM59bQ' ssh -o StrictHostKeyChecking=no username@server.example.com`

```
SSHPASS='t@uyM59bQ' sshpass -e ssh vivek@server42.cyberciti.biz
SSHPASS='t@uyM59bQ' sshpass -e ssh vivek@server42.cyberciti.biz date
SSHPASS='t@uyM59bQ' sshpass -e ssh vivek@server42.cyberciti.biz w
SSHPASS='t@uyM59bQ' sshpass -e ssh -o StrictHostKeyChecking=no vivek@server42.cyberciti.biz
```
### read pass from file
```
$ echo 'myPassword' &gt; myfile
$ chmod 0400 myfile
$ sshpass -f myfile ssh vivek@server42.cyberciti.biz
```

## rsync with password

` rsync --rsh="sshpass -p myPassword ssh -l username" server.example.com:/var/www/html/ /backup/`
or
` SSHPASS='yourPasswordHere' rsync --rsh="sshpass -e ssh -l username" server.example.com:/var/www/html/ /backup/`

## pscp & psftp (windows to linux)

- `pscp C:\Users\jbsmith\directory\*.txt jbsmith@cheyenne.ucar.edu:/glade/u/home/$USER`

```
psftp> lcd ..\documents
psftp> lcd documents
New local directory is C:\Users\jbsmith\documents
psftp> put file1.txt
local:file1.txt => remote:/glade/u/home/jbsmith/file1.txt
psftp> cd /glade/scratch/jbsmith
Remote directory is now /glade/scratch/jbsmith
psftp> mput file*.txt
local:file1.txt => remote:/glade/scratch/jbsmith/file1.txt
local:file2.txt => remote:/glade/scratch/jbsmith/file2.txt
local:file3.txt => remote:/glade/scratch/jbsmith/file3.txt
psftp>
```

