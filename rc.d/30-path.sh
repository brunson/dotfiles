debug .bash/path.sh
for dir in /usr/local/sbin /usr/local/sbin /Users/eric.brunson/Library/Python/3.8/bin ~/bin ~/.local/bin ; do
    [ -d "$dir" ] && PATH=$dir:$PATH
done

