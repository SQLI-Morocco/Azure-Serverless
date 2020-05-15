#!/bin/bash

# add all parameters

echo "Add IOT HUB parmas"
. ./iot-hub/params.sh
echo "Add Storage account parmas"
. ./storageaccount/params.sh
echo "Add EventHub parmas"
. ./eventhub/params.sh
echo "Add ASA parmas"
. ./AzureStreamAnalytics/params.sh
echo "Add Azure function parmas"
. ./AzureFunction/params.sh

echo "Creating IOT HUB"
. ./iot-hub/script.sh
echo "Creating Storage account"
. ./storageaccount/script.sh
echo "Creating EventHub"
. ./eventhub/script.sh
echo "Creation ASA"
. ./AzureStreamAnalytics/script.sh
echo "Creating Azure function "
. ./AzureFunction/script.sh