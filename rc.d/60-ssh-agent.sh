ssh-add -l >&- 2>&-
if [[ $? -eq 2 ]] ; then
    echo no ssh agent
else
    # keep JuiceSSH agent from hanging
    ssh-add -l | grep -q JuiceSSH
    if [[ $? -ne 0 ]] ; then
	DIR=~/.ssh
	for key in id_rsa id_rsa_gitlab id_rsa_github; do
	    [ -f $DIR/$key ] && ssh-add -l | grep -qw $key || echo adding $key ; ssh-add $DIR/$key 2>&- | grep -sv "Identity added:" || :
	done
    fi
fi

