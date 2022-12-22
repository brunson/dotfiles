
DIR=~/.ssh

for key in id_rsa id_rsa_gitlab id_rsa_github; do
    [ -f $DIR/$key ] && ssh-add -l | grep -qw $key || ssh-add $DIR/$key 2>&- | grep -sv "Identity added:" || :
done

