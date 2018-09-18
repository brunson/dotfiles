
for key in ~/.ssh/id_rsa_gitlab ~/.ssh/idt_development.pem ~/.ssh/idt_production_aws_2.pem ~/.ssh/id_rsa_lima ; do
   [ -f $key ] && ssh-add $key 2>&- | grep -sv "Identity added:" || :
done

