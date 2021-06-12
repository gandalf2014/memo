@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco list
choco install --force jdk8 tomcat eclipse notepadplusplus googlechrome atom 7zip.portable virtualbox docker-toolbox dbeaver \
virtualbox.extensionpack virtualbox-guest-additions-guest.install kubernetes-cli minikube git.portable putty.portable wget \
conemu winscp.portable smartftp keepass.portable xnviewmp.portable filezilla.commandline qdir ngrok.portable
vscode vlc openssh autohotkey.portable vcredist140 foxitreader curl gimp python3 chromium git-lfs office365business vagrant winmerge
everything cpu-z.install beyondcompare docker-compose autoit.commandline filezilla.server ynote internet-download-manager
wechat tim
