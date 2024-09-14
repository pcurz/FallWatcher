const aedes = require('aedes')();
const net = require('net');
const { generateQRCode } = require('@qr/qrGenerator');

const qrCodes = {};

const server = net.createServer(aedes.handle);
const mqttPort = 1883;

function startMQTTBroker() {
  server.listen(mqttPort, () => {
    console.log(`MQTT broker running on port ${mqttPort}`);
  });

  aedes.on('publish', (packet, client) => {
    const topic = packet.topic;
    const message = packet.payload.toString();

    if (topic === 'devices/register') {
      const macAddress = message;
      console.log(`Received MAC address: ${macAddress}`);

      generateQRCode(macAddress).then(qrCodeUrl => {
        qrCodes[macAddress] = qrCodeUrl;
        console.log(`QR code generated for MAC: ${macAddress}`);
      }).catch(err => {
        console.error('Error generating QR code:', err);
      });
    }
  });
}

function getQRCode(macAddress) {
  return qrCodes[macAddress];
}

module.exports = {
  startMQTTBroker,
  getQRCode,
};
