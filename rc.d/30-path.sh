debug .bash/path.sh

PYTHON=/Library/Frameworks/Python.framework/Versions/3.10
export VIRTUALENVWRAPPER_PYTHON=$PYTHON/bin/python3

for dir in /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin ~/bin ~/.local/bin $PYTHON/bin ; do
    [ -d "$dir" ] || continue
    echo $PATH | tr : \\n | grep -q ^${dir}$ && continue
    PATH=$dir:$PATH
done

[[ -r "$PYTHON/bin/virtualenvwrapper.sh" ]] && . "$PYTHON/bin/virtualenvwrapper.sh"
