debug .bash/path.sh
for dir in /usr/local/sbin /bin ~/bin ~/.local/bin ; do
    [ -d "$dir" ] || continue
    echo $PATH | tr : \\n | grep -q ^${dir}$ && continue
    PATH=$dir:$PATH
done

