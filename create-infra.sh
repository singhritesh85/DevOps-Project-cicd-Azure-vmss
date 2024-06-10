#!/bin/bash
DEXTER=`/opt/packer build template.json | tail -7 | head -1`
image_name=`echo $DEXTER|cut -d ":" -f2`
echo $image_name
az vmss update --resource-group vmss-resource-group --name mytestscaleset-1 --set virtualMachineProfile.storageProfile.imageReference.id="${image_name//[[:blank:]]/}"
az vmss update-instances --instance-ids '*' --resource-group vmss-resource-group --name mytestscaleset-1 --no-wait
