#!/bin/bash
#set -e
. ./params.sh

echo "Creating storage account"
az storage account create \
                --name $weather_storage_account_name \
                 --resource-group $resource_group_name \
                 --access-tier Hot --sku Standard_LRS \
                 --location $location

echo "Creating Table in the created storage account"
az storage table create --name $weather_data \
                        --account-name $weather_storage_account_name 
echo "Table Created"
echo "End of Creating storage account script"




