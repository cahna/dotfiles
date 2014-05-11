#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import git-prompt for __git_ps1 usage
[[ -f /usr/share/git/completion/git-prompt.sh ]] && source /usr/share/git/completion/git-prompt.sh

#
# HELPERS
#

# Display color codes and combinations (call from shell)
colors() {
  local fgc bgc vals seq0

  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      printf " ${seq0}TEXT\e[m"
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    done
    echo; echo
  done
}

#
# Color Helpers: https://wiki.archlinux.org/index.php/Color_Bash_Prompt#A_well-established_Bash_color_prompt
#

# Color/text reset
ColorOff="\[\033[0m\]"

# Foreground colors
Black="\[\033[0;30m\]"
Red="\[\033[0;31m\]"
Green="\[\033[0;32m\]"
Yellow="\[\033[0;33m\]"
Blue="\[\033[0;34m\]"
Magenta="\[\033[0;35m\]"
Cyan="\[\033[0;36m\]"
White="\[\033[0;37m\]"

# Emphasized foreground colors
BBlack="\[\033[1;30m\]"
BRed="\[\033[1;31m\]"
BGreen="\[\033[1;32m\]"
BYellow="\[\033[1;33m\]"
BBlue="\[\033[1;34m\]"
BMagenta="\[\033[1;35m\]"
BCyan="\[\033[1;36m\]"
BWhite="\[\033[1;37m\]"

__battery_status() {
  local SMAPI=/sys/devices/platform/smapi
  local BAT=$SMAPI/BAT0
  local ac_conn=$(cat $SMAPI/ac_connected)
  local bat_perc=$(cat $BAT/remaining_percent)

  local charge_sym="${Green}+"
  if [ $ac_conn -eq 0 ]; then
    charge_sym="${Yellow}-"
  fi
  
  local bat_color="${Red}"
  if [ $bat_perc -gt 20 ]; then 
    bat_color="${Yellow}"
  elif [ $bat_perc -gt 50 ]; then
    bat_color="${Green}"
  fi

  echo "${charge_sym}${bat_color}${bat_perc}"
}

#
# PS1 Configuration
#

bash_prompt() {
  local EXIT="$?"

  # Clean up PWD
  local pwdmaxlen=25
  local trunc_symbol=".."
  local dir=${PWD##*/}
  pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
  local NEW_PWD=${PWD/#$HOME/\~}
  local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
  if [ ${pwdoffset} -gt "0" ]
  then
    NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
    NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
  fi

  local UC=$Blue   # User color
  local EC=$Red    # Exit status code color
  local C=$White   # Symbol character colors

  # Change user colors for root
  if [ $UID -eq "0" ]; then
    UC=$Red
    MC=$BRed
  fi

  # Change color if return status is bad
  if [ $? -eq 0 ]; then
    EC=$Green
  fi

  # Handle format and color of specific eleents
  local HOST="${Green}\h"
  local DIR="${Cyan}${NEW_PWD}"
  local USER="${UC}\u"
  local BATT_STATUS="$(__battery_status)${White}%"
  local EXIT_COLOR="\$(if [ $EXIT -eq 0 ]; then echo \"${White}\"; else echo \"${BRed}\"; fi)"
  local GIT_INFO="\$(if [ -d ./.git ]; then echo \" $C(\$(if [[ \$(git status --short | sed -s 's/^ //g' | cut -d' ' -f1 | wc -l) > 0 ]]; then echo \"$Red\"; else echo \"$Green\"; fi)\$(__git_ps1 '%s')$C)\"; fi)"
  local HOST_INFO="${C}[${USER}${Red}@${HOST}${C}:${DIR}${C}] ${BATT_STATUS}${GIT_INFO}${ColorOff}"

  PS1="\n${HOST_INFO}\n$EXIT_COLOR\$>${ColorOff} "
  PS2="${BWhite}>${ColorOff} "
}

PROMPT_COMMAND=bash_prompt

#
# User / Desktop settings
#

TZ='America/Kentucky/Louisville'; export TZ
#TZ='America/Chicago'; export TZ

# Default editor = vim
export EDITOR=vim

# Environment variables to colorize 'man'
export LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' 

# Unbind Ctrl+S and Ctrl+Q from screen output (conflicts with rtorrent)
stty stop undef
stty start undef

# Ruby is stupid as hell
PATH=$PATH:/home/cheine/.gem/ruby/2.0.0/bin
export GEM_HOME=~/.gem/ruby/2.0.0

# Colorize the ls output ##
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias l.='ls -ld .* --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='colordiff'
alias ports='netstat -tulanp'

# Buckle up for safety
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Others
alias df='df -H'
alias du='du -ch'
alias torchrocks='luarocks --server=https://raw.github.com/torch/rocks/master'

# Fix line wrap on window size
shopt -s checkwinsize

#if [ "$PS1" ]; then
  # Display a fortune
#  echo -e "\n$(/usr/bin/fortune)"
#fi

