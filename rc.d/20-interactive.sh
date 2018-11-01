# -*- Mode: shell-script; -*-
debug .bash/interactive.sh

if [ $( basename $SHELL ) = bash ]
then
    alias print=echo
fi

case "$-" in
    *i*) stty erase  
         set -o ignoreeof 4
         for dir in /usr/local/bin/ /usr/share/virtualenvwrapper/ ; do
             file=$dir/virtualenvwrapper.sh
             [ -f $file ] && . $file && break
         done
	;;
esac

umask 022

export GOPATH=~

alias olab='sudo openvpn --config ~/.openvpn/ericb.ovpn'
alias osec='sudo openvpn ~/shared/OS-41975-PWK.ovpn &'
alias odisco='sudo pkill -TERM openvpn'
alias nmsec='nmcli c up OS-41975-PWK'
alias nmdisco='nmcli c down OS-41975-PWK'
alias rdp='nohup rdesktop -g 70% -r disk:bin=/usr/share/windows-binaries -r disk:mydisk=/media/sf_VMShared -u offsec -p cvBwE2P7G3z -a 16 win &'
alias rdpxl='nohup rdesktop -g 90% -r disk:bin=/usr/share/windows-binaries -r disk:mydisk=/media/sf_VMShared -u offsec -p cvBwE2P7G3z -a 16 win &'
alias rmkey='ssh-keygen -R'
alias blk='black -l 104 --py36'
alias j='jobs -l'
alias ls='ls -F --color'
alias clear=/usr/bin/clear
alias setdate='date `date +%y%m%d%H%m`'
alias more=less
alias trcrt="traceroute -q 1 -w 2"
alias teams='curl -s http://bonzai-api-svc.prd.valkyrie.net/api/v1/teams'
alias scan='sudo nmap -sS -sV -vv -T5 -Pn --script banner --open'
alias sweep='sudo nmap -Sn'
alias proxy='export HTTP_PROXY=http://www-proxy-brmdc.us.oracle.com'
alias noproxy='unset HTTP_PROXY'
alias adsearch='ldapsearch -h p-shared-dc01.valkyrie.net. -D "qldap" -E pr=1000/noprompt -x -b "ou=Employees,dc=valkyrie,dc=net" -o ldif-wrap=no -w $(cat ~/.qldap)'

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

