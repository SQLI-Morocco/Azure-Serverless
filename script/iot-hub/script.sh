#!/bin/bash
#set -e
. ./params.sh
##Create a resource group 
echo "Create resource group"
az group create --name $resource_group_name  --location $location
## install Azure clit iot extenstion 'Should be done from azure cloud shell'
##az extension add --name azure-cli-iot-ext

##Create IOT hub and add device to the IOT HUB
echo "Create IOT Hub"
az iot hub create --name $iot_hub_name \
                     --resource-group $resource_group_name  \
                     --location $location --sku $sku
##Create iot device 
echo "Create a device to connect to the IOT hub"
az iot hub device-identity create --device-id $iot_device_name \
                                  --hub-name $iot_hub_name \
                                  --edge-enabled false \
                                  --resource-group $resource_group_name

##Get device connection string 
echo "Add IOT Hub Manage policy"
az iot hub policy create --hub-name $iot_hub_name \
                         --name $iot_hub_manage_policy --permissions RegistryWrite ServiceConnect DeviceConnect \
                         --resource-group $resource_group_name -o json

echo "Connection string to be used to connect your device to the IOT hub :"

az iot hub device-identity show-connection-string \
                                                            --device-id $iot_device_name  \
                                                            --hub-name $iot_hub_name  \
                                                            --resource-group $resource_group_name -o  json \
                                                            --query connectionString

