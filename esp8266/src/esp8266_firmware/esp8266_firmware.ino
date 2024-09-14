#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <MPU6050.h>
#include <math.h>

const char* ssid = "";
const char* password = "";
const char* mqtt_server = "";

WiFiClient espClient;
PubSubClient client(espClient);
MPU6050 mpu;

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "NodeMCU-" + WiFi.macAddress();
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");

      String macAddress = WiFi.macAddress();
      Serial.print("Publishing MAC Address: ");
      Serial.println(macAddress);

      client.publish("devices/register", macAddress.c_str());
      
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void detectFall() {
  int16_t ax, ay, az, gx, gy, gz;
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  
  // Convertir a unidades adecuadas
  float accelX = ax / 16384.0;
  float accelY = ay / 16384.0;
  float accelZ = az / 16384.0;
  float gyroX = gx / 131.0;
  float gyroY = gy / 131.0;
  float gyroZ = gz / 131.0;
  
  float accelTotal = sqrt(pow(accelX, 2) + pow(accelY, 2) + pow(accelZ, 2));
  
  // should adjust
  float gyroThreshold = 150.0;
  float angle = acos(accelZ / accelTotal) * 180.0 / PI;

  if (accelTotal > 2.0 || abs(gyroX) > gyroThreshold || abs(gyroY) > gyroThreshold || abs(gyroZ) > gyroThreshold || angle > 60) {
    Serial.println("Fall detected!");
    
    String macAddress = WiFi.macAddress();
    String topic = "nodemcu/" + macAddress + "/fall";
    client.publish(topic.c_str(), "fall");
    
    delay(5000);
  }
}

void printIMUData() {
  int16_t ax, ay, az, gx, gy, gz;
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  
  float accelX = ax / 16384.0;
  float accelY = ay / 16384.0;
  float accelZ = az / 16384.0;
  
  float gyroX = gx / 131.0;
  float gyroY = gy / 131.0;
  float gyroZ = gz / 131.0;
  
  Serial.print("Acceleration X: "); Serial.print(accelX); Serial.print(" g, ");
  Serial.print("Y: "); Serial.print(accelY); Serial.print(" g, ");
  Serial.print("Z: "); Serial.print(accelZ); Serial.println(" g");

  Serial.print("Gyroscope X: "); Serial.print(gyroX); Serial.print(" deg/s, ");
  Serial.print("Y: "); Serial.print(gyroY); Serial.print(" deg/s, ");
  Serial.print("Z: "); Serial.print(gyroZ); Serial.println(" deg/s");

  delay(500);
}

void setup() {
  Serial.begin(9600);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  Wire.begin();
  mpu.initialize();
  
  if (!mpu.testConnection()) {
    Serial.println("MPU6050 connection failed");
    while (1);
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  printIMUData();
  detectFall();
}
