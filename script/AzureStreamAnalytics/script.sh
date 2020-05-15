#!/bin/bash
#set -e
. ./params.sh


iot_hub_manage_policy_sas=$(az iot hub policy list --hub-name $iot_hub_name \
                                --resource-group $resource_group_name \
                                --query "[?contains(keyName, 'manage')].primaryKey" -o tsv)
storage_account_key=$(az storage account keys list \
                             --account-name $weather_storage_account_name \
                             --query "[?contains(keyName, 'key1')].value" -o tsv)


eh_policy_send_primary_key=$(az eventhubs namespace authorization-rule  keys list \
                                 --resource-group  $resource_group_name \
                                  --namespace-name $event_Hubs_namespace \
                                  --name $sendauthorule -o tsv --query primaryKey)


echo "Start executing ARM deployment to create ASA"
az deployment group create --resource-group $resource_group_name \
                            --name $deploymentName  \
                            --template-file $template_file \
                            --parameters StreamAnalyticsJobName=$streamAnalyticsJobName \
                             Location=$location \
                             Input_WeatherAlertIoTHubInput_iotHubNamespace=$iot_hub_name \
                             Output_WeatherAlertEventhubOutput_serviceBusNamespace=$event_Hubs_namespace \
                             Output_WeatherAlertEventhubOutput_eventHubName=$event_hub_name \
                             Output_WeatherAlertEventhubOutput_sharedAccessPolicyName=$sendauthorule \
                             Output_WeatherAlertStorageTableOutput_accountName=$weather_storage_account_name \
                             Output_WeatherAlertStorageTableOutput_table=$weather_data \
                             Output_WeatherAlertStorageTableOutput_partitionKey=$deviceId \
                             Output_WeatherAlertStorageTableOutput_rowKey=$enqueuedTimeUtc \
                             Input_WeatherAlertIoTHubInput_sharedAccessPolicyName=$iot_hub_manage_policy \
                             Input_WeatherAlertIoTHubInput_sharedAccessPolicyKey=$iot_hub_manage_policy_sas \
                             Output_WeatherAlertEventhubOutput_sharedAccessPolicyKey=$eh_policy_send_primary_key \
                             Output_WeatherAlertStorageTableOutput_accountKey=$storage_account_key

