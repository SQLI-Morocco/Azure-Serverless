#!/bin/bash
#set -e
. ./params.sh



azurequeues_sharedkey=$(az storage account keys list \
                         --account-name  $weather_storage_account_name \
                         --query "[?contains(keyName, 'key1')].value" -o tsv)


echo "Start executing ARM deployment to create LogicAPP"
az deployment group create --resource-group $resource_group_name \
                            --name $deploymentName  \
                            --template-file $logicapp_template_file \
                            --parameters logicAppName=$logicAppName \
                              azurequeues_storageaccount=$weather_storage_account_name \
                              azurequeues_sharedkey=$azurequeues_sharedkey \
                              email_to=$email_to \
                              sendgrid_apiKey=$send_grid_api_key


