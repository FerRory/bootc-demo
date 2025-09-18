#!/bin/bash
GROUP=tf-bootc-demo
STORAGE_ACCOUNT=terraformbootcimages
STORAGE_CONTAINER=terraformbootcimages

# Get storage account connection string based on info above
export CONNECTION=$(az storage account show-connection-string \
                    -n $STORAGE_ACCOUNT \
                    -g $GROUP \
                    -o tsv)

 az storage blob upload \
  --connection-string $CONNECTION \
  --container-name $STORAGE_CONTAINER \
  -f ./output/vpc/disk.vhd \
  --overwrite \
  -n bootc-azure.vhd


