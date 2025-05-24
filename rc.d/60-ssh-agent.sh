ssh-add -l >&- 2>&-
if [[ $? -ne 2 ]] ; then
    # keep JuiceSSH agent from hanging
    ssh-add -l | grep -q JuiceSSH
    if [[ $? -ne 0 ]] ; then
	DIR=~/.ssh
	# for key in id_rsa id_rsa_gitlab id_rsa_github id_rsa_key_systems ; do
	for key in id_rsa id_rsa_github ; do
	    if [ -f $DIR/$key ] ; then
		ssh-add -l | grep -qw $key || echo adding $key >&2 ; ssh-add $DIR/$key 2>&- | grep -sv "Identity added:" || :
	    fi
	done
    fi
fi

