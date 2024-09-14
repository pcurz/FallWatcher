# Node.js MQTT Server

**MQTT server** using **Aedes** as the broker, and generates **QR codes** for devices based on their MAC addresses. Devices (like NodeMCU) can connect to this server, send their MAC address, and receive a scannable QR code for identification.

## Features

- **MQTT Broker**: The server runs an MQTT broker using **Aedes**, handling connections from devices like NodeMCU.
- **QR Code Generation**: For every device that publishes its **MAC address**, a corresponding **QR code** is generated and stored.
- **Express Web Server**: The server hosts an Express web server to display QR codes. You can access the QR codes by visiting a specific URL in the browser.
- **Absolute Imports**: The server is structured using absolute imports for better maintainability.

## Project Structure

```
mqtt-server/
│
├── src/
│   ├── config/
│   │   └── config.js            # Configuration settings
│   ├── mqtt/
│   │   └── broker.js            # MQTT broker setup using Aedes
│   ├── qr/
│   │   └── qrGenerator.js       # QR code generation logic
│   ├── server/
│   │   └── webServer.js         # Express web server to serve QR codes
│   └── index.js                 # Entry point for the server
│
├── package.json                 # Dependencies
└── README.md                    
```

## Setup Instructions

### 1. Prerequisites

- **Node.js**: Ensure you have Node.js >=v22 installed. You can download it from [nodejs.org](https://nodejs.org).
- **npm**: Node's package manager should be installed along with Node.js.

### 2. Installing Dependencies

After cloning the repository, navigate to the project folder and run:

```bash
npm install
```

This installs all the required packages such as **Aedes**, **Express**, **QRCode**, and **module-alias**.

### 3. Running the Server

To start the MQTT broker and the Express web server:

```bash
npm run start
```

### 4. Accessing the Web Server

The **Express web server** will be running on **port 3000** by default. Once a device publishes its MAC address, you can access its QR code at:

```
http://localhost:3000/qrcode/[MAC_ADDRESS]
```

For example, if the device's MAC address is `5C:CF:7F:12:34:56`, you would visit:

```
http://localhost:3000/qrcode/5C:CF:7F:12:34:56
```

### 5. Project Configuration

The project configurations are located in the **`src/config/config.js`** file:

```javascript
module.exports = {
  serverPort: 80,
};
```

You can modify this file to change the server's settings (e.g., change the port for the web server).

### Project Details

#### **MQTT Broker** (`src/mqtt/broker.js`)

- The MQTT broker is set up using **Aedes**.
- Devices connect to the broker and publish their MAC address to the topic **`devices/register`**.
- The broker listens for messages on this topic and generates a QR code for each MAC address.

#### **QR Code Generation** (`src/qr/qrGenerator.js`)

- QR codes are generated using the **qrcode** library.
- The generated QR codes are stored in memory and served through the web server.

#### **Web Server** (`src/server/webServer.js`)

- The **Express** server serves QR codes via a URL in the format `/qrcode/[MAC_ADDRESS]`.
- The server listens on the port defined in **`config.js`**.
