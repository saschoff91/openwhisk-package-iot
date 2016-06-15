/*
 * Copyright 2015-2016 IBM Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * An action to create new device Type in Watson IoT platform.
 * @param      {string}  apiKey                    (required)  Watson IoT platform apiKey
 * @param      {string}  authToken                 (required)  Authentication token of an Watson IoT platform
 * @param      {string}  orgId                     (required)  IoT platform Organization Id
 * @param      {string}  typeId                    (required)  Device Type Id
 * @param      {string}  serialNumber              (optional)  The serial number of the device type
 * @param      {string}  manufacturer              (optional)  The manufacturer of the device
 * @param      {string}  model                     (optional)  The model of the device
 * @param      {string}  deviceClass               (optional)  The class of the device
 * @param      {string}  description               (optional)  The descriptive name of the device
 * @param      {string}  fwVersion                 (optional)  The firmware version currently known to be on the device
 * @param      {string}  hwVersion                 (optional)  The hardware version of the device
 * @param      {string}  descriptiveLocation       (optional)  A descriptive location, such as a room or building number, or a geographical region
 * @param      {object}  metadata                  (optional)  Metadata of the device
 * @return     {Object}                                        Done with the result of invokation
 **/
var request = require('request');

function main(params) {

    var requiredParams = ["apiKey", "authToken", 'orgId', 'typeId', 'deviceId', 'eventName', 'eventBody'];

    checkParameters(params, requiredParams, function(missingParams) {
        if (missingParams != "") {
            console.error("Missing required parameters: " + missingParams);
            return whisk.error("Missing required parameters: " + missingParams);
        } else {
            var baseUrl = 'https://' + params.orgId + '.internetofthings.ibmcloud.com:443/api/v0002';

            var authorizationHeader = "Basic " + new Buffer(params.apiKey + ":" + params.authToken).toString("base64");


            var deviceInfo = {
                "serialNumber": params.serialNumber, //optional
                "manufacturer": params.manufacturer, //optional
                "model": params.model, //optional
                "deviceClass": params.deviceClass, //optional
                "description": params.description, //optional
                "fwVersion": params.fwVersion, //optional
                "hwVersion": params.hwVersion, //optional
                "descriptiveLocation": params.descriptiveLocation //optional
            };

            var metadata = params.metadata;
            var body = {
                "id": params.id, //required
                "description": params.description, //optional
                "classId": "Device",
                "deviceInfo": deviceInfo,
                "metadata": metadata
            };

            var options = {
                method: 'POST',
                url: baseUrl + "/device/types",
                body: JSON.stringify(body),
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': authorizationHeader
                }
            };


            request(options, function(err, res, body) {
                if (!err && res.statusCode === 201) {
                    var b = JSON.parse(body);
                    whisk.done(b);

                } else {
                    whisk.error({
                        statusCode: (res || {}).statusCode,
                        error: err,
                        body: body
                    });
                }
            });

        }
    });
    return whisk.async();
}


/**
 *  A function that check whether the parameters passed are required or not
 *
 * @param      {object}    params    An object contains the parameter required
 *                                   in otder to check it and generate a sting
 *                                   that contains list of missing parameters
 * @param      {Function}  callback  the callback function has the generated
 *                                   string or an empyt string if the params is
 *                                   empty
 */
function checkParameters(params, requiredParams, callback) {
    console.log("Checking Existiance of Required Parameters");
    var missingParams = [];
    for (var i = requiredParams.length - 1; i >= 0; i--) {
      console.log(requiredParams[i]);
        if (!params.hasOwnProperty(requiredParams[i])) {
            missingParams.push(requiredParams[i]);
        }
        if (i == 0)
            return callback(missingParams);

    }
}