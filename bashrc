# .bashrc

debug .bashrc

for rcfile in /etc/bashrc /etc/bash_completion ~/.dotfiles/rc.d/*.sh ; do
    if [ -f "$rcfile" ]; then
	debug sourcing $rcfile
        source "$rcfile"
    fi
done

