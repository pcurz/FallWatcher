import 'package:fallwatcherapp/blocs/theme_cubit.dart';
import 'package:fallwatcherapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../blocs/device_cubit.dart';
import '../models/device_model.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  Future<void> _showNotification(String deviceName) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'fallwatcherapp_channel',
      'FallWatcher',
      channelDescription: 'Notifications for fall detection',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        'A fall has been detected on the device $deviceName. Please check the status immediately.',
        contentTitle: 'Fall Detected!',
      ),
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      null,
      null,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FallWatcher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              bool isDark = Theme.of(context).brightness == Brightness.dark;
              context.read<ThemeCubit>().toggleTheme(!isDark);
            },
          ),
        ],
      ),
      body: BlocBuilder<DeviceCubit, List<Device>>(
        builder: (context, devices) {
          if (devices.isEmpty) {
            return const Center(child: Text('No devices'));
          }
          for (var device in devices) {
            if (device.status == 'fall') {
              _showNotification(device.name);
            }
          }
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];

              IconData deviceIcon;
              Color? tileColor;

              if (device.status == 'fall') {
                deviceIcon = Icons.warning;
                tileColor =
                    Theme.of(context).colorScheme.error.withOpacity(0.1);
              } else {
                deviceIcon = Icons.device_hub;
                tileColor = Theme.of(context).cardColor;
              }

              return ListTile(
                leading:
                    Icon(deviceIcon, color: Theme.of(context).iconTheme.color),
                title: Text(
                  device.name,
                  style: TextStyle(
                    color: device.status == 'fall'
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                subtitle: Text(
                  'Status: ${device.status == 'fall' ? 'Fall Detected!' : 'Good'}',
                  style: TextStyle(
                    color: device.status == 'fall'
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                tileColor: tileColor,
                trailing: device.status == 'fall'
                    ? ElevatedButton(
                        onPressed: () {
                          context
                              .read<DeviceCubit>()
                              .updateDeviceStatus(device.mac, 'good');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: const Text('Confirm OK'),
                      )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/qr_scan');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
