#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Default editor = vim
export EDITOR=vim

# Import git-prompt for __git_ps1 usage
[[ -f /usr/share/git/completion/git-prompt.sh ]] && source /usr/share/git/completion/git-prompt.sh

# Unbind Ctrl+S and Ctrl+Q from screen output (conflicts with rtorrent)
stty stop undef
stty start undef

#export PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] O "; else echo "\[\e[31m\] X "; fi\[\e[01;37m\][[ $(git status 2> /dev/null | head -n2 | tail -n1) != "# Changes to be committed:" ]] && echo " \[\e[31m\]" || echo "\[\e[33m\] "``[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] || echo "\[\e[32m\]"`$(__git_ps1 "(%s)\[\e[00m\]")\[\e[01;34m\]\w\[\e[00m\]\n\u:\$ '

PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\$?\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

## Colorize the ls output ##
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias l.='ls -ld .* --color=auto'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# install  colordiff package :)
alias diff='colordiff'

# Show open ports
alias ports='netstat -tulanp'

alias rm='rm --preserve-root'
