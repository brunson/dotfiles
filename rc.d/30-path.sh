debug .bash/path.sh

BREW=/opt/homebrew
PYTHON=/Library/Frameworks/Python.framework/Versions/3.10
export VIRTUALENVWRAPPER_PYTHON=$PYTHON/bin/python3

case $(uname -s) in
    Darwin)
	DIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin $BREW/bin $BREW/opt/coreutils/libexec/gnubin $PYTHON/bin $HOME/.local/bin $HOME/bin blarg"
	;;
    *)
	DIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin ~/.local/bin ~/bin"
	;;
esac


NEW_PATH=""
for dir in $DIRS ; do
    [ -d "$dir" ] || continue
    echo "$NEW_PATH" | tr : \\n | grep -q ^${dir}$ && continue
    if [[ -z "$NEW_PATH" ]] ; then
	NEW_PATH=$dir
    else
	NEW_PATH=$dir:$NEW_PATH
    fi
done
[[ -z "$NEW_PATH" ]] || PATH=$NEW_PATH

[[ -r "$PYTHON/bin/virtualenvwrapper.sh" ]] && . "$PYTHON/bin/virtualenvwrapper.sh"
