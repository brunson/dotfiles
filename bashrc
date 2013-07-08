# .bashrc

debug() {
    if [[ ! -z "$DEBUG_ENV" ]] ; then
	echo "$@"
    fi
}
if [[ -f ~/.debug_env ]] ; then
    DEBUG_ENV=True
fi

debug .bashrc

for rcfile in /etc/bashrc /etc/bash_completion ~/.dotfiles/*.sh ; do
    if [ -f "$rcfile" ]; then
	debug sourcing $rcfile
        source "$rcfile"
    fi
done

