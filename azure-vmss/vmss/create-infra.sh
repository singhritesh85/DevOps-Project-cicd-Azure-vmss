#!/bin/bash

az sig create --resource-group ritesh --gallery-name nhimagegallery
az sig image-definition create --resource-group ritesh --gallery-name nhimagegallery --gallery-image-definition demo --publisher OpenLogic --offer CentOS --sku 7_9-gen2 --os-type linux --hyper-v-generation V2
/opt/packer plugins install github.com/hashicorp/azure 
/opt/packer plugins install github.com/hashicorp/ansible
DEXTER=`/opt/packer build template.json | tail -7 | head -1`
image_id=`echo $DEXTER|cut -d ":" -f2`
echo $image_id
echo 'variable "image_id" { default = "'${image_id//[[:blank:]]/}'" }' > newvariable.tf
terraform init
terraform apply -auto-approve
