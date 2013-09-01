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

debug $USER $(basename $HOME)
if [ "$USER" = $(basename $HOME) ]
then
	PS1='-\n\h(\w$(__git_ps1 "[%s]"))\n\$ '
else
	PS1='\u@\h(\w)\$ '
	PS1='-\n\u@\h(\w$(__git_ps1 "[%s]"))\n\$ '
fi

ungit() {
    PS1='-\n\h(\w)\n\$ '
}