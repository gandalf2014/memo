## zsh installation steps
> https://www.howtoforge.com/tutorial/how-to-setup-zsh-and-oh-my-zsh-on-linux/

- apt install zsh
- chsh -s /bin/zsh root
- apt install wget git
- wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
- cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
- zsh
- source ~/.zshrc

- vim ~/.zshrc
- ZSH_THEME='risto'
- plugins=(git extract web-search yum git-extras docker vagrant colored-man-pages colorize command-not-found docker man rsync rvm vagrant-prompt)
- source ~/.zshrc


# install_zsh.sh

#!/usr/bin/env bash
cmd="yum"
more /etc/os-release | grep "^ID=ubuntu" && cmd="apt-get" 

"$cmd" update -y && "$cmd" install zsh && chsh -s /bin/zsh root && "$cmd" install wget git 
 wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh 
 cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc   
 sed -i "s/^ZSH_THEME=.*/ZSH_THEME='risto'/" ~/.zshrc 
 sed -i "s/# ZSH_THEME_RANDOM_CANDIDATES/ZSH_THEME_RANDOM_CANDIDATES/" ~/.zshrc 
 sed -i "56d; 56i plugins=(git extract web-search yum git-extras docker vagrant colored-man-pages \
 colorize command-not-found docker man rsync rvm vagrant-prompt)"  ~/.zshrc 
 zsh && source ~/.zshrc


 ## simple scripts
export http_proxy=http://10.8.22.153:7890
export https_proxy=http://10.8.22.153:7890
 sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
 sed -i "s/^ZSH_THEME=.*/ZSH_THEME='risto'/" ~/.zshrc 
 sed -i "s/# ZSH_THEME_RANDOM_CANDIDATES/ZSH_THEME_RANDOM_CANDIDATES/" ~/.zshrc 
 sed -i "56d; 56i plugins=(git extract web-search yum git-extras docker vagrant colored-man-pages \
 colorize command-not-found docker man rsync rvm vagrant-prompt)"  ~/.zshrc 