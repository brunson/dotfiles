# -*- Mode: shell-script; -*-
debug .bash/interactive.sh

if [ $( basename $SHELL ) = bash ]
then
    alias print=echo
fi

case "$-" in
    *i*) stty erase  
         set -o ignoreeof 4
         [ -f /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh
	;;
esac

umask 022

export GOPATH=~

alias lab='sudo openvpn --config ~/.openvpn/ericb.ovpn'
alias j='jobs -l'
alias use=workon
alias ls='ls -F'
alias clear=/usr/bin/clear
alias lgit='sudo -u lnxbuild git'
alias setdate='date `date +%y%m%d%H%m`'
alias more=less
alias trcrt="traceroute -q 1 -w 2"
alias fixmp3names='rename "s/ /_/g ; s/_-_/-/g ; s/-_/-/g ; s/_-/-/g ; s/--*/-/g ; tr/A-Z/a-z/ ; s/%([1-9][0-9])/unpack('\''c'\'',)/g"'
alias hclock='TZ=Asia/Calcutta xclock -analog -name Hyderabad'
alias lnx='sudo -u lnxbuild'
alias teams='curl -s http://bonzai-api-svc.prd.valkyrie.net/api/v1/teams'

function autopep
{
    for dir in odc tests $* ; do
	if [ -e $dir ] ; then
	    find $dir -name \*.py | while read file ; do
		autopep8 -i $file
	    done
	fi
    done
}

function metadata
{
    curl http://169.254.169.254/latest/meta-data/$1/
    echo
}

function userdata
{
    curl http://169.254.169.254/latest/user-data
    echo
}

function activate
{
    . $1/bin/activate
}

function netgroups
{
    egrep $1 /usr/local/etc/common/netgroup/netgroup | cut -d' ' -f1
}

function gmt
{
    TZ=UCT date
}

function mysql
{
    command mysql $MYSQLPASSWORD "$@"
}

function mysqldump
{
    command mysqldump $MYSQLPASSWORD "$@"
}

function mark 
{
    export "path_$1"="${2:-`pwd`}"
}

function d 
{
    typeset pdir=path_$1
    typeset dir=`eval echo '${'$pdir'}'`/$2
    [ "/" = "$dir" ] && { echo "mark for $1 not set" ; return 1 ; }
    cd $dir
}

function unmark 
{ 
    unset path_$1
}

function marks 
{
    set | grep ^path_ | sed "s/^path_//
		 	     s/=/	/"
}

function savemarks
{
    marks > ~/.marks
}

function readmarks
{
    [ -f ~/.marks ] || return 0
    while read line
    do 
        set $line
        name=$1
        shift
        path=$@
        mark $name $path
    done < ~/.marks
}
readmarks


function su 
{
	settit "#`hostname`"
	command su $@
	settit
}


function settit 
{
    if [ "$1" = "" ]; then
	typeset one="$(hostname)"
    else
	typeset one="$@"
    fi

    if [ "$(whoami)" = "root" ]; then
	typeset text="# $one"
    else
	typeset text=$one
    fi

    if  [[ $TERM == xterm || $TERM == xterm-*color ]]; then
	typeset _esc=""
	typeset _ctlg=""
	echo -n "${_esc}]0;$text${_ctlg}" >&2
	echo -n "${_esc}]2;$text${_ctlg}" >&2
    else 
	if  [ $LAYER ]; then
		layertitle $text
	fi 
    fi
}

settit


function st 
{	
    export TERM=$1
}


function ssh 
{
    local temp="$@"
    shift $(( $# - 1 ))
    settit $1
    command ssh $temp
    settit
}


function telnet 
{
    settit $1
    command telnet $*
    settit
}


function sd 
{	
    export DISPLAY=$1:0
}


function sld 
{
    export DISPLAY=unix:0
}


function ffh 
{ 
    find ~ -name "*$1*" -print
}

function ff
{ 
    find . -name .snapshot -prune -o -name "*$1*" -print
}

function ff0
{ 
    find . -name .snapshot -prune -o -name "*$1*" -print0
}

# find file, exec GREP with arg
# fgh 'text'    --- find files which match 'text', print the names   

#       home dir version
function fgh 
{ 
    if [ "$1" ]; then find ~ -type f -exec grep -Hs "$1" {} \; -print ; fi 
}

#       current dir version 
function fgr 
{ 
    if [ "$1" ]; then find . -type f -exec grep -Hs "$1" {} \; -print ; fi 
}

#       current dir version 
function fgw 
{ 
    if [ "$1" ]; then find . -type f -exec grep -wHs "$1" {} \; -print ; fi 
}

# find verbose
function fv  
{ 
    if [ "$1" ]; then find . -type f -exec grep "$1" {} \; -print ; fi 
}

function fvi  
{ 
    if [ "$1" ]; then find . -type f -exec grep -i "$1" {} \; -print ; fi 
}

# find directory by name
#       from home directory
function fdh  
{ 
    find ~ -type d -name "*$1*" -print 
}

#       from current directory
function fd  
{ 
    find . -type d -name "*$1*" -print  
}

function flh  
{ 
    find ~ -type l -name "*$1*" -exec ls -l {} \; 
}

function fl  
{ 
    find . -type l -name "*$1*" -exec ls -l {} \; 
}

function fll  
{ 
    find . -type l -name "*$1*" -exec ls -lL {} \; 
}

function undo 
{
    rm -f ~/.netscape/history.*
    rm -f $HISTFILE
    unset HISTFILE
    # exit
}

function saveprompt 
{
    ops1="$PS1"
    PS1="$ "
}

function restoreprompt 
{
    if [ ! -z "$ops1" ]
    then
	PS1="$ops1"
    fi
}

function oneach
{
    site=$1
    shift
    
    for server in s1 s2 s3 s4 s5
    do
	echo $server.$site.mgmt.l3.net >&2
	ssh -l root $server.$site.mgmt.l3.net "$@"
    done
}

prompt_command() 
{ 
    prompt_status=$?
    if [ $prompt_status != 0 ]
    then
        echo "[status $prompt_status]"
    fi
}
PROMPT_COMMAND=prompt_command

