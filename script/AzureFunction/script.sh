#!/bin/bash
. ./params.sh

echo $resource_group_name

storage_account_connection_string=$(az storage account show-connection-string \
                                    --name  $weather_storage_account_name --resource-group \
                                    $resource_group_name --output tsv)

eh_policy_read_primary_connection_string=$(az eventhubs namespace authorization-rule  keys list \
                                          --resource-group  $resource_group_name  \
                                          --namespace-name $event_Hubs_namespace \
                                          --name $readauthorule -o tsv --query primaryConnectionString)

az functionapp deployment source update-token --git-token $token

echo "Create the function app"

az functionapp create --resource-group $resource_group_name \
                         --name $weatheralertfunction \
                         --storage-account $weather_storage_account_name \
                         --runtime dotnet   \
                         --functions-version 3   \
                         --consumption-plan-location $location \
                         --deployment-source-url $gitrepo \
                         --deployment-source-branch master
echo "Setup function settings"

az functionapp config appsettings set \
                         --resource-group $resource_group_name \
                         --name $weatheralertfunction \
                         --settings  "weather_alert_storage_account=$storage_account_connection_string"

az functionapp config appsettings set \
                        --resource-group $resource_group_name --name \
                        $weatheralertfunction \
                        --settings  "EventHubConnectionString=$eh_policy_read_primary_connection_string"

echo "Strat Fcuntion"
az functionapp start --resource-group $resource_group_name --name $weatheralertfunction 