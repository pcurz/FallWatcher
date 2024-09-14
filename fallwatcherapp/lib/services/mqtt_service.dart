import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  static final MqttServerClient client = MqttServerClient('', '');

  static Future<void> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 20;

    try {
      print('Connecting to MQTT Broker...');
      await client.connect("fallwatcherapp");
      print('Connected!');
    } catch (e) {
      print('Connection failed: $e');
      client.disconnect();
    }
  }

  static Future<void> subscribe(String mac, Function(String) onMessage) async {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      await connect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      final topic = 'nodemcu/$mac/fall';
      client.subscribe(topic, MqttQos.atLeastOnce);

      client.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
        final MqttPublishMessage recMessage =
            messages![0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        onMessage(message);
      });
    } else {
      print('Failed to connect to MQTT server.');
    }
  }
}
