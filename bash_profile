# .bash_profile

debug() {
    if [[ ! -z "$DEBUG_ENV" ]] ; then
	echo "$@"
    fi
}
if [[ -f ~/.debug_env ]] ; then
    DEBUG_ENV=True
fi

debug .bash_profile

source ~/.bashrc
