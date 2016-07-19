#!/bin/bash

#/
# Copyright 2015-2016 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#/

set -e
set -x

if [ $# -eq 0 ]
then
    echo "Usage: ./install.sh <apihost> <authkey> <pathtowskcli>"
fi

APIHOST="$1"
AUTH="$2"
WSK_CLI="$3"

PACKAGE_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo Installing Watson IoT Platform Package \

$WSK_CLI --apihost "$APIHOST" package update --auth "$AUTH" --shared yes /whisk.system/iot \
    -a description "Watson IoT Platform Service Package" \
    -a parameters '[{"name":"apiKey","required":true,"bindTime":true,"description":"Watson IoT platform apiKey"},{"name":"apiToken","required":true,"bindTime":true,"type":"password","description":"Watson IoT platform authentication token"},{"name":"orgId","required":false,"bindTime":false,"description":"Watson IoT platform organization ID"}]'

$WSK_CLI --apihost "$APIHOST" action update --auth "$AUTH" --shared yes /whisk.system/iot/create_device_type "$PACKAGE_HOME/actions/create_device_type.js" \
    -a description 'Create new device Type in Watson IoT platform' \
    -a parameters '[{"name":"apiKey","required":true,"bindTime":true,"description":"Watson IoT platform API Key"},{"name":"apiToken","required":true,"bindTime":true,"description":"Authentication token of an Watson IoT platform","type":"password"},{"name":"orgId","required":true,"bindTime":true,"description":"IoT platform Organization Id"},{"name":"typeId","required":true,"bindTime":true,"description":"Device Type ID"},{"name":"serialNumber","required":false,"bindTime":false,"description":"Serial number of the device"},{"name":"manufacturer","required":false,"bindTime":false,"description":"Manufacturer of the device"},{"name":"model","required":false,"bindTime":false,"description":"Model of the device"},{"name":"deviceClass","required":false,"bindTime":false,"description":"Class of the device"},{"name":"description","required":false,"bindTime":false,"description":"Descriptive name of the device"},{"name":"fwVersion","required":false,"bindTime":false,"description":"Firmware version currently known to be on the device"},{"name":"hwVersion","required":false,"bindTime":false,"description":"Hardware version of the device"},{"name":"descriptiveLocation","required":false,"bindTime":false,"description":"Descriptive location, such as a room or building number, or a geographical region"},{"name":"metadata","required":false,"bindTime":false,"description":"Metadata of the device"}]' \
    -a sampleInput '{ "apiKey": "XXXXXX", "apiToken": "YYYYYY", "orgId": "ZZZZ", "typeId": "Raspberry_Pi" }' \
    -a sampleOutput '{"classId":"Device","createdDateTime":"2016-06-16T10:27:43+00:00","deviceInfo":{},"id":"Raspberry_Pi","updatedDateTime":"2016-06-16T10:27:43+00:00"}'

$WSK_CLI --apihost "$APIHOST" action update --auth "$AUTH" --shared yes /whisk.system/iot/delete_device_type "$PACKAGE_HOME/actions/delete_device_type.js" \
    -a description 'Create new device Type in Watson IoT platform' \
    -a parameters '[{"name":"apiKey","required":true,"bindTime":true,"description":"Watson IoT platform API Key"},{"name":"apiToken","required":true,"bindTime":true,"description":"Authentication token of an Watson IoT platform","type":"password"},{"name":"orgId","required":true,"bindTime":true,"description":"IoT platform Organization Id"},{"name":"typeId","required":true,"bindTime":true,"description":"Device Type ID"}]' \
    -a sampleInput '{ "apiKey": "XXXXXX", "apiToken": "YYYYYY", "orgId": "ZZZZ", "typeId": "Raspberry_Pi" }' \
    -a sampleOutput '{"successc":"device type deleted"}'

$WSK_CLI --apihost "$APIHOST" action update --auth "$AUTH" --shared yes /whisk.system/iot/register_device "$PACKAGE_HOME/actions/register_device.js" \
    -a description 'Register new device to Watson IoT platform' \
    -a parameters '[{"name":"apiKey","required":true,"bindTime":true,"description":"Watson IoT platform API Key"},{"name":"apiToken","required":true,"bindTime":true,"description":"Authentication token of an Watson IoT platform","type":"password"},{"name":"orgId","required":true,"bindTime":true,"description":"IoT platform Organization Id"},{"name":"deviceId","required":true,"bindTime":true, "description": "Device ID"},{"name":"typeId","required":true,"bindTime":true,"description":"Device Type ID"},{"name":"deviceAuthToken","required":false,"bindTime":false"type":"password"},{"name":"serialNumber","required":false,"bindTime":false,"description":"Serial number of the device"},{"name":"manufacturer","required":false,"bindTime":false,"description":"Manufacturer of the device"},{"name":"model","required":false,"bindTime":false,"description":"Model of the device"},{"name":"deviceClass","required":false,"bindTime":false,"description":"Class of the device"},{"name":"description","required":false,"bindTime":false,"description":"Descriptive name of the device"},{"name":"fwVersion","required":false,"bindTime":false,"description":"Firmware version currently known to be on the device"},{"name":"hwVersion","required":false,"bindTime":false,"description":"Hardware version of the device"},{"name":"descriptiveLocation","required":false,"bindTime":false,"description":"Descriptive location, such as a room or building number, or a geographical region"},{"name":"long","required":false,"bindTime":false,"description":"Longitude in decimal degrees using the WGS84 system"},{"name":"lat","required":false,"bindTime":false,"description":"Latitude in decimal degrees using the WGS84 system"},{"name":"elev","required":false,"bindTime":false,"description":"Elevation in meters using the WGS84 system"},{"name":"accuracy","required":false,"bindTime":false,"description":"Accuracy of the position in meters"},{"name":"measuredDateTime","required":false,"bindTime":false,"description":"Date and time of location measurement (ISO8601)"},{"name":"metadata","required":false,"bindTime":false,"description":"Metadata of the device"}]' \
    -a sampleInput '{ "apiKey": "XXXXXX", "apiToken": "YYYYYY", "orgId": "ZZZZ", "typeId": "Raspberry_Pi" ,"deviceId":"deviceId" }' \
    -a sampleOutput '{"apiToken":"xxxxxxxxx","clientId":"d:orgId:Raspberry_Pi:deviceId","deviceId":"deviceId","deviceInfo":{},"refs":{"diag":{"errorCodes":"/api/v0002/device/types/Raspberry_Pi/devices/deviceId/diag/errorCodes/","logs":"/api/v0002/device/types/Raspberry_Pi/devices/deviceId/diag/logs/"},"location":"/api/v0002/device/types/Raspberry_Pi/devices/deviceId/location/"},"registration":{"auth":{"id":"apiKey","type":"app"},"date":"2016-06-16T10:46:08.000Z"},"status":{"alert":{"enabled":false,"timestamp":"2016-06-16T10:46:08.965Z"}},"typeId":"Raspberry_Pi"}'

$WSK_CLI --apihost "$APIHOST" action update --auth "$AUTH" --shared yes /whisk.system/iot/delete_device "$PACKAGE_HOME/actions/delete_device.js" \
    -a description 'Delete a registered device.' \
    -a parameters '[{"name":"apiKey","required":true,"bindTime":true,"description":"Watson IoT platform API Key"},{"name":"apiToken","required":true,"bindTime":true,"description":"Authentication token of an Watson IoT platform","type":"password"},{"name":"orgId","required":true,"bindTime":true,"description":"IoT platform Organization Id"},{"name":"deviceId","required":true,"bindTime":true,"description":"Device ID"},{"name":"typeId","required":true,"bindTime":true,"description":"Device Type ID"}]' \
    -a sampleInput '{ "apiKey": "XXXXXX", "apiToken": "YYYYYY", "orgId": "ZZZZ", "typeId": "Raspberry_Pi", "deviceId":"deviceId"}' \
    -a sampleOutput '{"success":"device deleted"}'

$WSK_CLI --apihost "$APIHOST" action update --auth "$AUTH" --shared yes /whisk.system/iot/send_event "$PACKAGE_HOME/actions/send_event.js" \
    -a description 'Send events on behalf of a device (simplatuing a device) to Watson iot Platform.' \
    -a parameters '[{"name":"apiKey","required":true,"bindTime":true,"description":"Watson IoT platform API Key"},{"name":"apiToken","required":true,"bindTime":true,"description":"Authentication token of an Watson IoT platform","type":"password"},{"name":"orgId","required":true,"bindTime":true,"description":"IoT platform Organization Id"},{"name":"deviceId","required":true,"bindTime":true,"description":"Device ID"},{"name":"typeId","required":true,"bindTime":true,"description":"Device Type ID"},{"name":"eventName","required":true,"bindTime":true,"description":"Event Name"},{"name":"eventBody","required":true,"bindTime":true,"description":"Event Body"}]' \
    -a sampleInput '{"apiKey":"XXXXXX","apiToken":"YYYYYY","orgId":"ZZZZ","typeId":"Raspberry_Pi","deviceId":"deviceId","eventName":"temperature","{value:42}"}' \
    -a sampleOutput '{"success":"device deleted"}'
