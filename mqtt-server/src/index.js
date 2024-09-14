require('module-alias/register');
const { startMQTTBroker } = require('@mqtt/broker');
const { startWebServer } = require('@server/webServer');

// Start the MQTT broker
startMQTTBroker();

// Start the Express web server
startWebServer();