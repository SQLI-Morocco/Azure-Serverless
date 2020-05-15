#!/bin/bash
#set -e
. ./params.sh

az eventhubs namespace create --name $event_Hubs_namespace \
                              --resource-group $resource_group_name \
                              --location $location \
                              --enable-auto-inflate true \
                              --maximum-throughput-units 20 \
                              --sku Standard
#create write and right access policies
az eventhubs namespace authorization-rule create --resource-group  $resource_group_name \
                                                  --namespace-name $event_Hubs_namespace \
                                                   --name $sendauthorule \
                                                   --rights Send

az eventhubs namespace authorization-rule create --resource-group  $resource_group_name \
                                                 --namespace-name $event_Hubs_namespace \
                                                 --name $readauthorule \
                                                 --rights Listen



## Create an event hub. Specify a name for the event hub. 
az eventhubs eventhub create --name $event_hub_name \
                             --resource-group $resource_group_name \
                             --namespace-name $event_Hubs_namespace
