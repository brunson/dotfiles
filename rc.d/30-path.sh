debug .bash/path.sh

BREW=/opt/homebrew
PYTHON=/Library/Frameworks/Python.framework/Versions/3.10
MYPYTHON=/Users/ebrunson/Library/Python/3.10
GOPATH=/usr/local/go
export VIRTUALENVWRAPPER_PYTHON=$PYTHON/bin/python3

case $(/usr/bin/uname -s) in
    Darwin)
	DIRS="$GOPATH/bin /bin /usr/bin /sbin /usr/sbin /usr/local/bin $HOME/.rd/bin $BREW/bin $BREW/opt/coreutils/libexec/gnubin $MYPYTHON/bin $PYTHON/bin $HOME/.local/bin $HOME/bin"
	;;
    *)
	DIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin ~/.local/bin ~/bin"
	;;
esac

export PATH=/bin:/usr/bin

NEW_PATH=""
for dir in $DIRS ; do
    [ -d "$dir" ] || continue
    echo "$NEW_PATH" | /usr/bin/tr : \\n | /usr/bin/grep -q ^${dir}$ && continue
    if [[ -z "$NEW_PATH" ]] ; then
	NEW_PATH=$dir
    else
	NEW_PATH=$dir:$NEW_PATH
    fi
done
[[ -z "$NEW_PATH" ]] || PATH=$NEW_PATH

[[ -r "$PYTHON/bin/virtualenvwrapper.sh" ]] && . "$PYTHON/bin/virtualenvwrapper.sh"
