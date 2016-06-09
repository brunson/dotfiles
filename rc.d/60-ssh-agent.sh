
for key in ~/.ssh/id_rsa_su ~/.ssh/id_rsa_gitlab ~/.ssh/idt_development.pem ~/.ssh/idt_production_aws_2.pem ~/.ssh/id_rsa_lima ; do
   ssh-add $key
done

