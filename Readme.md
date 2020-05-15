#### **Azure Serverless components**

Azure offers a variety of services that we can use to build application, one of the possibilities it offers is to create serverless  application. Serverless computing is the abstraction of servers, infrastructure, and operating systems. Serverless is consumption-based, which means that you don't need to anticipate any capacity, this different from using PaaS services, you still pay for the reserved compute.

**Weather Alert Scenario**
In this example  I'm going to build weather alert system ,using a bunch of Azure Serverless component , the idea is to connect Azure environment to the IoT device , this device is going to send data to the cloud , and within the cloud environment I’m going to use Servless component  to manage, store and route data , in the end the system is going to send email alert when the temperature is greater than a given thresholder

In this demo I’m using :

*  IoT Hub : To connect IoT device to Azure cloud environment
*  Azure Stream Analytics : To mange data in motion form the IoT hub
*  Storage Account
*  Table : To store all data coming from the IoT device ‘cool storag’
*  Queue : to queue message alert before sending  alerts
*  Event Hub : To connect different component in azure within azure environment
*  Azure Function : serverless function will be in charge of getting data form from the event hub and storing it in the Queue
*  LogicAPP : Get the alert from the queue and send emails alert

![image](https://github.com/SQLI-Morocco/Azure-Serverless/blob/master/img/weatheralert.JPG)
*NB : we are not oblige to use all of this component to our scenario , the idea is just to present the maximum of azure  serverless component*
<br>


#####