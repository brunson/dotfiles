debug .bash/path.sh

if [[ $(uname) == "Darwin" ]] ; then
    BREW=/opt/homebrew
    PYTHON=/Library/Frameworks/Python.framework/Versions/3.11
    MYPYTHON=/Users/ebrunson/Library/Python/3.11
    GOPATH=/usr/local/go
    export VIRTUALENVWRAPPER_PYTHON=$PYTHON/bin/python3
else
    PYTHON=$(which python3)
    MYPYTHON=$PYTHON
    VIRTUALENVWRAPPER_PYTHON=$PYTHON
fi

case $(/usr/bin/uname -s) in
    Darwin)
        debug Darwin
        DIRS="$GOPATH/bin /bin /usr/bin /sbin /usr/sbin /usr/local/bin $HOME/.rd/bin $BREW/bin $BREW/opt/coreutils/libexec/gnubin $MYPYTHON/bin $PYTHON/bin $HOME/.local/bin $HOME/bin"
        ;;
    *)
        debug not Darwin
        DIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin $HOME/.local/bin $HOME/bin"
        ;;
esac

export PATH=/bin:/usr/bin

NEW_PATH=""
for dir in $DIRS ; do
    debug process $dir
    [ -d "$dir" ] || continue
    echo "$NEW_PATH" | /usr/bin/tr : \\n | /usr/bin/grep -q ^${dir}$ && continue
    debug add $dir
    if [[ -z "$NEW_PATH" ]] ; then
        NEW_PATH=$dir
    else
        NEW_PATH=$dir:$NEW_PATH
    fi
done
debug NEW_PATH=$NEW_PATH
debug PATH=$PATH
[[ -z "$NEW_PATH" ]] || PATH=$NEW_PATH
debug PATH=$PATH

[[ -r "$PYTHON/bin/virtualenvwrapper.sh" ]] && . "$PYTHON/bin/virtualenvwrapper.sh"
