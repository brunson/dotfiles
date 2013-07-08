# -*- Mode: sh; -*-
debug .bash/envvariables

shopt -s histappend

VISUAL=vi
PAGER=less
LESS="-i -j5 -m -S -X -R"
export LESS PAGER VISUAL

HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=1000

export ORACLE_HOME=/usr/local/oracle
export TNS_ADMIN=$ORACLE_HOME
export ORACLE_SID=PROD_EDT01
export TZ=MST7MDT

export WS=/local/mnt/workspace/$USER
export COMMANDER_SERVER=commander-test.qualcomm.com
export BAIT_SCM_COMMANDER_SERVER="$COMMANDER_SERVER"

export USE_CCACHE=1
export CCACHE_DIR=/local/scratch/ebrunson/work/.ccache

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
#GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWCOLORHINTS=1


Black="0;30"
Blue="0;34"
Green="0;32"
Cyan="0;36"
Red="0;31"
Purple="0;35"
Brown="0;33"
Blue="0;34"
Green="0;32"
Cyan="0;36"
Red="0;31"
Purple="0;35"
Brown="0;33"
colorize() {
    echo "\e[$@]\e[m"
}
