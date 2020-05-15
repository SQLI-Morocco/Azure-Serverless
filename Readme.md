#### **Azure Serverless components**

Azure offers a variety of services that we can use to build application, one of the possibilities it offers is to create serverless  application. Serverless computing is the abstraction of servers, infrastructure, and operating systems. Serverless is consumption-based, which means that you don't need to anticipate any capacity, this different from using PaaS services, you still pay for the reserved compute.

**Weather Alert Scenario**
In this example  I'm going to build weather alert system ,using a bunch of Azure Serverless component , the idea is to connect Azure environment to the IoT device , this device is going to send data to the cloud , and within the cloud environment I’m going to use Servless component  to manage, store and route data , in the end the system is going to send email alert when the temperature is greater than a given thresholder

In this demo I’m using :

* IoT Hub : To connect IoT device to Azure cloud environment
* Azure Stream Analytics : To mange data in motion form the IoT hub
* Storage Account
* Table : To store all data coming from the IoT device ‘cool storag’
* Queue : to queue message alert before sending  alerts
* Event Hub : To connect different component in azure within azure environment
* Azure Function : serverless function will be in charge of getting data form from the event hub and storing it in the Queue
* LogicAPP : Get the alert from the queue and send emails alert

![image](https://github.com/SQLI-Morocco/Azure-Serverless/blob/master/img/weatheralert.JPG)

*NB : We are not oblige to use all of this component to our scenario , the idea is just to present the maximum of azure  serverless component<br>
        In this article I’m using Azure Cli command over linux bash shell to provision Azure components<br>
        I'm using Raspberry PI simulator, to simulate an IoT device   [https://azure-samples.github.io/raspberry-pi-web-simulator/](https://azure-samples.github.io/raspberry-pi-web-simulator/)*

<br>
###### **IoT Hub**

<br>
IoT Hub offers two way communication, from devices to Azure (D2C) and from Azure to devices (C2D), itcan process millions of event per second and support multiple protocols such as MQTT, AMQP, MQTT over socket ,AMQP over socket   HTTPS, and file upload.
IoT Hub secure connection between the cloud and devices by using device identity and shared access policies.

With the script bellow  we create IoT hub , after that we create a device within the IoT hub, a resource group is created to contain all the components for this demo.
<br>
``` bash
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
echo "Add IoT Hub Manage policy"
az iot hub policy create --hub-name $iot_hub_name \
                         --name $iot_hub_manage_policy \
                         --permissions RegistryWrite ServiceConnect DeviceConnect \
                         --resource-group $resource_group_name -o json

echo "Connection string to be used to connect your device to the IoT hub :"

az iot hub device-identity show-connection-string \
                         --device-id $iot_device_name  \
                         --hub-name $iot_hub_name  \
                         --resource-group $resource_group_name -o  json \
                         --query connectionString
```
<br>
Once the IoT Hub and the IoT hub device is created , get the connection string from the last query to configure the device.
for this demo we are using Azure simulator , please change the connection string in the node JS code with your connection string , and click start.

The simulator start sending telemetry to the cloud ,if you check in your IoT hub metric bled you will see telemetry coming to the cloud from your device

**Storage Account**

Azure offers variaty type of storage  account that can be used to store all sort of data in Azure  (Blob storage, Table , Queue , File,disk)
for this demo , we create a storage account with a table storage , this table is going to be used as cool storage to store all the data coming from the device
with th script bellow create a storage account and a table in the created storage account.

<br>

``` bash
echo "Creating storage account"
az storage account create \
                --name $weather_storage_account_name \
                 --resource-group $resource_group_name \
                 --access-tier Hot --sku Standard_LRS \
                 --location $location

echo "Creating Table in the created storage account"
az storage table create --name $weather_data \
                        --account-name $weather_storage_account_name 
echo "Table Created"
echo "End of Creating storage account script"
```
