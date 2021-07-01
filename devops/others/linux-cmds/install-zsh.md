## zsh installation steps
> https://www.howtoforge.com/tutorial/how-to-setup-zsh-and-oh-my-zsh-on-linux/

- apt install zsh
- chsh -s /bin/zsh root
- apt install wget git
- wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
- cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
- source ~/.zshrc

- vim ~/.zshrc
- ZSH_THEME='risto'
- plugins=(git extract web-search yum git-extras docker vagrant colored-man-pages colorize command-not-found docker man rsync rvm vagrant-prompt)
- source ~/.zshrc
