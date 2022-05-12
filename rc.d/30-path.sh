debug .bash/path.sh

for dir in /usr/local/bin /usr/local/sbin /opt/homebrew/bin /bin ~/bin ~/.local/bin /Library/Frameworks/Python.framework/Versions/3.10/bin ; do
    [ -d "$dir" ] || continue
    echo $PATH | tr : \\n | grep -q ^${dir}$ && continue
    PATH=$dir:$PATH
done

