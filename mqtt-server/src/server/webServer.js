const express = require('express');
const { getQRCode } = require('@mqtt/broker');
const config = require('@config/config');

const app = express();

app.get('/qrcode/:mac', (req, res) => {
  const macAddress = req.params.mac;
  const qrCode = getQRCode(macAddress);

  if (qrCode) {
    res.send(`<img src="${qrCode}" alt="QR Code for MAC: ${macAddress}" />`);
  } else {
    res.status(404).send('QR Code not found for this MAC address');
  }
});

function startWebServer() {
  app.listen(config.serverPort, () => {
    console.log(`Web server running at http://localhost:${config.serverPort}`);
  });
}

module.exports = {
  startWebServer,
};
