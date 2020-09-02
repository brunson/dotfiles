debug .bash/path.sh
for dir in /usr/local/sbin /bin ~/.local/bin ; do
    [ -d "$dir" ] && PATH=$dir:$PATH
done

