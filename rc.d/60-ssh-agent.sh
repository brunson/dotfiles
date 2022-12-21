
for key in ~/.ssh/id_rsa ~/.ssh/id_rsa_gitlab ~/.ssh/id_rsa_github; do
   [ -f $key ] && ssh-add $key 2>&- | grep -sv "Identity added:" || :
done

