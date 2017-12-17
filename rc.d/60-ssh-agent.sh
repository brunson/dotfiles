return

for key in ~/.ssh/id_github_rsa ~/.ssh/id_rsa_codecommit ~/.ssh/id_rsa; do
   ssh-add $key
done

