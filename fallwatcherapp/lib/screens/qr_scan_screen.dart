import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/device_cubit.dart';
import '../models/device_model.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedMAC;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Device')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Pausar la cámara cuando se escanea el QR
      controller.pauseCamera();
      setState(() {
        scannedMAC = scanData.code;
      });
      _showNameDialog();
    });
  }

  Future<void> _showNameDialog() async {
    TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Device Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Device Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                controller?.resumeCamera();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty && scannedMAC != null) {
                  // Guardar el dispositivo en el Bloc
                  context
                      .read<DeviceCubit>()
                      .addDevice(Device(mac: scannedMAC!, name: name));
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
