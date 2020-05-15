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
*NB : We are not oblige to use all of this component to our scenario , the idea is just to present the maximum of azure  serverless component*
        In this article I’m using Azure Cli command over linux bash shell to provision Azure components
         I'm using Raspberry PI simulator, to simulate an IoT device   [https://azure-samples.github.io/raspberry-pi-web-simulator/](https://azure-samples.github.io/raspberry-pi-web-simulator/)

<br>
<br>
**IoT Hub**
IoT Hub offers two way communication, from devices to Azure (D2C) and from Azure to devices (C2D), itcan process millions of event per second and support multiple protocols such as MQTT, AMQP, MQTT over socket ,AMQP over socket   HTTPS, and file upload.
IoT Hub secure connection between the cloud and devices by using device identity and shared access policies

<span class="colour" style="color: rgb(106, 153, 85);">##Create IOT hub and add device to the IOT HUB</span>
<span class="colour" style="color: rgb(220, 220, 170);">echo</span><span class="colour" style="color: rgb(212, 212, 212);"> </span><span class="colour" style="color: rgb(206, 145, 120);">"Create IoT Hub"</span>
<span class="colour" style="color: rgb(212, 212, 212);">az iot hub create --name </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_hub\_name</span><span class="colour" style="color: rgb(212, 212, 212);"> \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                     --resource-group </span><span class="colour" style="color: rgb(156, 220, 254);">$resource\_group\_name</span><span class="colour" style="color: rgb(212, 212, 212);">  \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                     --location </span><span class="colour" style="color: rgb(156, 220, 254);">$location</span><span class="colour" style="color: rgb(212, 212, 212);"> --sku </span><span class="colour" style="color: rgb(156, 220, 254);">$sku</span>
<span class="colour" style="color: rgb(156, 220, 254);"></span>
<span class="colour" style="color: rgb(106, 153, 85);">##Create iot device </span>
<span class="colour" style="color: rgb(220, 220, 170);">echo</span><span class="colour" style="color: rgb(212, 212, 212);"> </span><span class="colour" style="color: rgb(206, 145, 120);">"Create a device to connect to the IOT hub"</span>
<span class="colour" style="color: rgb(212, 212, 212);">az iot hub device-identity create --device-id </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_device\_name</span><span class="colour" style="color: rgb(212, 212, 212);"> \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                  --hub-name </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_hub\_name</span><span class="colour" style="color: rgb(212, 212, 212);"> \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                  --edge-enabled </span><span class="colour" style="color: rgb(220, 220, 170);">false</span><span class="colour" style="color: rgb(212, 212, 212);"> \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                  --resource-group </span><span class="colour" style="color: rgb(156, 220, 254);">$resource\_group\_name</span>

<span class="colour" style="color: rgb(106, 153, 85);">##Get device connection string </span>
<span class="colour" style="color: rgb(220, 220, 170);">echo</span><span class="colour" style="color: rgb(212, 212, 212);"> </span><span class="colour" style="color: rgb(206, 145, 120);">"Add IOT Hub Manage policy"</span>
<span class="colour" style="color: rgb(212, 212, 212);">az iot hub policy create --hub-name </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_hub\_name</span><span class="colour" style="color: rgb(212, 212, 212);"> \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                         --name </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_hub\_manage\_policy</span><span class="colour" style="color: rgb(212, 212, 212);"> --permissions RegistryWrite ServiceConnect DeviceConnect \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                         --resource-group </span><span class="colour" style="color: rgb(156, 220, 254);">$resource\_group\_name</span><span class="colour" style="color: rgb(212, 212, 212);"> -o json</span>

<span class="colour" style="color: rgb(220, 220, 170);">echo</span><span class="colour" style="color: rgb(212, 212, 212);"> </span><span class="colour" style="color: rgb(206, 145, 120);">"Connection string to be used to connect your device to the IOT hub :"</span>

<span class="colour" style="color: rgb(212, 212, 212);">az iot hub device-identity show-connection-string \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                                            --device-id </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_device\_name</span><span class="colour" style="color: rgb(212, 212, 212);">  \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                                            --hub-name </span><span class="colour" style="color: rgb(156, 220, 254);">$iot\_hub\_name</span><span class="colour" style="color: rgb(212, 212, 212);">  \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                                            --resource-group </span><span class="colour" style="color: rgb(156, 220, 254);">$resource\_group\_name</span><span class="colour" style="color: rgb(212, 212, 212);"> -o  json \</span>
<span class="colour" style="color: rgb(212, 212, 212);">                                                            --query connectionString</span>

<br>
<br>
