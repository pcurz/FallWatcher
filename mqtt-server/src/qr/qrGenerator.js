const QRCode = require('qrcode');


const options = {
  scale: 10,
  width: 500,
  errorCorrectionLevel: 'H',
}

function generateQRCode(macAddress) {
  return QRCode.toDataURL(macAddress, options);
}
module.exports = {
  generateQRCode,
};
