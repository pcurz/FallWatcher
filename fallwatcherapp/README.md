# FallWatcherApp - Flutter Application

This folder contains the **Flutter application** for FallWatcher. The app is designed to interact with ESP8266-based fall detection devices through an MQTT broker. It provides real-time notifications when a fall is detected and allows users to manage connected devices.

## Overview

- **Add Devices**: Scan and add devices using their MAC address via QR code.
- **Fall Detection Notifications**: Receive real-time notifications when a fall is detected by any of the connected devices.
- **Acknowledge Fall**: Users can confirm that a device is OK after a fall has been detected.
- **Dark and Light Themes**: The app supports both light and dark modes.

## Prerequisites

- **Flutter SDK**: Ensure you have the Flutter SDK installed. [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- **MQTT Broker**: You need an MQTT broker running (e.g., the one from the `mqtt-server/` folder of this repository) and accessible from your device.
- **ESP8266 Devices**: Fall detection devices must be set up and publishing messages to the MQTT broker.

## Installation

1. **Navigate to the Flutter app directory**:

   ```bash
   cd FallWatcher/fallwatcherapp
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Set the MQTT Broker IP**:
   
   Before running the app, you need to configure the MQTT broker IP address. Open the `mqtt_service.dart` file located in the `lib/services/` directory:

   ```dart
   static final MqttServerClient client = MqttServerClient('', '');
   ```

   Replace with the actual IP address of your MQTT broker. This is necessary for the app to connect to the correct broker.

5. **Run the Flutter app** on an emulator or physical device:

   ```bash
   flutter run
   ```

## Features

### 1. **Adding a Device**

- Press the `+` button in the bottom-right corner of the app to scan and add a device.
- Scan the device's QR code to capture its MAC address.
- After scanning, enter a name for the device, and it will be added to the list.

### 2. **Fall Detection**

- The app will notify you when a fall is detected by one of the devices.
- The affected device will be highlighted in the list with a warning icon and a "Fall Detected" message.
- Press the "Confirm OK" button next to the device to reset its status to normal.

### 3. **Notifications**

- When a fall is detected, you will receive a real-time notification.
- The notification will include the device's name and a message prompting you to check the status.

## MQTT Configuration

Make sure the MQTT broker is set up and running. The Flutter app connects to the broker using the IP specified in `mqtt_service.dart`. The MQTT broker should handle messages on topics such as:

```
nodemcu/{device_mac}/fall
```

Replace `{device_mac}` with the actual MAC address of each device.

### Example Message Flow

1. The device publishes a message to the topic `nodemcu/{device_mac}/fall` when a fall is detected.
2. The MQTT broker forwards the message to the Flutter app.
3. The Flutter app processes the message, updates the UI, and sends a notification to the user.

## Themes

The app supports light and dark themes. You can toggle between the themes using the theme switch button in the top-right corner of the app.