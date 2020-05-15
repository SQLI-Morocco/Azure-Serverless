deploymentName="asa_deployment"
template_file="../../StreamAnalytic/weatheralertsa/Deploy/asa-weatheralert.JobTemplate.json"

enqueuedTimeUtc="EventEnqueuedUtcTime"
deviceId="deviceId"
streamAnalyticsJobName="weatherasa" 

. ../eventhub/params.sh
. ../iot-hub/params.sh
. ../storageaccount/params.sh