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

for rcfile in /etc/bashrc /etc/bash_completion ~/.dotfiles/rc.d/*.sh ; do
    if [ -f "$rcfile" ]; then
	debug sourcing $rcfile
        source "$rcfile"
    fi
done


export PERL_LOCAL_LIB_ROOT="/usr2/ebrunson/perl5";
export PERL_MB_OPT="--install_base /usr2/ebrunson/perl5";
export PERL_MM_OPT="INSTALL_BASE=/usr2/ebrunson/perl5";
export PERL5LIB="/usr2/ebrunson/perl5/lib/perl5/x86_64-linux-gnu-thread-multi:/usr2/ebrunson/perl5/lib/perl5";
export PATH="/usr2/ebrunson/perl5/bin:$PATH";
