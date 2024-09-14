# ESP8266 MQTT Client

**NodeMCU/ESP8266** firmware that connects to a local **MQTT server**, publishes the **MAC address**, and monitors for events (e.g., fall detection). The MQTT server generates a **QR code** for each connected device based on its MAC address.

## Features

- **WiFi Connection**: The NodeMCU connects to a WiFi network.
- **MQTT Client**: The NodeMCU connects to an MQTT broker and publishes its **MAC address** to the topic `devices/register`.
- **Fall Detection**: The firmware includes fall detection using an MPU6050 sensor.

## Prerequisites

### Hardware

- **NodeMCU (ESP8266)**
- **MPU6050 Accelerometer/Gyroscope sensor**

### Software

- **Arduino IDE**: Download it from [here](https://www.arduino.cc/en/software).

## Setup Instructions

### 1. Library Installation

In the **Arduino IDE**, you need to install the following libraries:

- **PubSubClient**: For MQTT communication.
- **ESP8266WiFi**: For WiFi connectivity (typically included with the ESP8266 core).

To install these:
- Open the Arduino IDE.
- Go to **Sketch > Include Library > Manage Libraries...**.
- Search for **PubSubClient** and click "Install".

### 2. Wiring (Optional for MPU6050)

If you're using the **MPU6050** for fall detection, connect it to the **NodeMCU** as follows:

- **VCC → 3.3V**
- **GND → GND**
- **SCL → D1 (GPIO5)**
- **SDA → D2 (GPIO4)**

### 3. Flashing the NodeMCU

1. Open the **Arduino IDE**.
2. Open (`esp8266_firmware.ino`) into the Arduino IDE.
3. Select the correct **Board** and **Port**:
   - Go to **Tools > Board > NodeMCU 1.0 (ESP-12E Module)**.
   - Select the correct **Port** where your NodeMCU is connected.
4. Update the following values in the code with your WiFi and MQTT broker details:
   ```cpp
   const char* ssid = "";
   const char* password = "";
   const char* mqtt_server = "";
   ```
5. Upload the code to your NodeMCU.

### 4. MQTT Workflow

Once the NodeMCU is connected:
- It will publish its **MAC address** to the topic **`devices/register`**.
- The MQTT server will receive the MAC address and generate a QR code.
