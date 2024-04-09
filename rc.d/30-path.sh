debug .bash/path.sh

if [[ $(uname) == "Darwin" ]] ; then
    BREW=/opt/homebrew
    PYTHON=/Library/Frameworks/Python.framework/Versions/3.12/bin/python3
    GOPATH=/usr/local/go
else
    PYTHON=$(which python3)
fi
export VIRTUALENVWRAPPER_PYTHON=$PYTHON

case $(/usr/bin/uname -s) in
    Darwin)
        debug Darwin
        DIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin $HOME/.rd/bin $BREW/bin $BREW/opt/coreutils/libexec/gnubin $(dirname $PYTHON) $HOME/.local/bin $HOME/bin /Users/ebrunson/.cargo/bin $GOPATH/bin"
        ;;
    *)
        debug not Darwin
        DIRS="/bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin $HOME/.local/bin $HOME/bin /snap/bin"
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

if [[ $(uname) == "Darwin" ]] ; then
    . virtualenvwrapper.sh
fi
