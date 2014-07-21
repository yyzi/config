alias vi='vim'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias prefixnet='bash ~/scripts/pre-fix-net.sh'
alias fixnet='perl ~/scripts/fix-net.pl'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# vim 方式操作
#set -o vi

# 终端配色
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# 命令提示
#export PS1='\D{[%m-%d %H:%M:%S} \h \W]$ '
export PS1='\n[\D{%m-%d %H:%M:%S} \e[1;37m\e[1;31m`hostname -d|tr a-z A-Z` \e[m\e[1;32m\u\e[m\e[1;33m@\e[m\e[1;35m\h\e[m \e[4m`pwd`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\$'

# less 命令显示中文
export LESS=-isMrf

# 语言环境
export LANG=C
export LC_CTYPE=en_US.UTF-8

export GOPATH=$HOME/lib/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

