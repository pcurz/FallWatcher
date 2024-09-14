import 'dart:convert';

import 'package:fallwatcherapp/services/mqtt_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';

class DeviceCubit extends Cubit<List<Device>> {
  final MQTTService mqttService;

  DeviceCubit(this.mqttService) : super([]) {
    loadDevices();
  }

  void loadDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? deviceList = prefs.getStringList('devices');

    if (deviceList != null) {
      final devices = deviceList.map((deviceStr) {
        Map<String, dynamic> deviceMap = jsonDecode(deviceStr);
        return Device.fromJson(Map<String, String>.from(deviceMap));
      }).toList();

      emit(devices);

      for (Device device in devices) {
        MQTTService.subscribe(device.mac, (message) {
          updateDeviceStatus(
            device.mac,
            message == 'fall' ? 'fall' : 'good',
          );
        });
      }
    }
  }

  void addDevice(Device device) async {
    bool deviceExists =
        state.any((existingDevice) => existingDevice.mac == device.mac);

    if (deviceExists) {
      return;
    }
    final updatedDevices = List<Device>.from(state)..add(device);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> deviceList =
        updatedDevices.map((device) => jsonEncode(device.toJson())).toList();

    await prefs.setStringList('devices', deviceList);
    emit(updatedDevices);
    MQTTService.subscribe(device.mac, (message) {
      updateDeviceStatus(device.mac, message == 'fall' ? 'fall' : 'good');
    });
  }

  void updateDeviceStatus(String mac, String status) {
    final updatedDevices = state.map((device) {
      if (device.mac == mac) {
        device.status = status;
      }
      return device;
    }).toList();
    emit(updatedDevices);
  }
}
