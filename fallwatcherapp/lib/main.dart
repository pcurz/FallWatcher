import 'package:fallwatcherapp/services/mqtt_service.dart';
import 'package:fallwatcherapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/device_cubit.dart';
import 'blocs/theme_cubit.dart';
import 'screens/device_list_screen.dart';
import 'screens/qr_scan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();

  final mqttService = MQTTService();
  await MQTTService.connect();
  runApp(FWApp(mqttService: mqttService));
}

class FWApp extends StatelessWidget {
  final MQTTService mqttService;

  const FWApp({super.key, required this.mqttService});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeviceCubit(mqttService)),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'FallWatcher',
            theme: theme,
            home: const DeviceListScreen(),
            routes: {
              '/qr_scan': (context) => const QRScanScreen(),
            },
          );
        },
      ),
    );
  }
}
