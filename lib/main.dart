import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '01_presentation/BluetoothOffScreen/bluetooth_off_screen.dart';
import '01_presentation/FindDevicesScreen/find_devices_screen.dart';
import '01_presentation/login/login.dart';
import 'constants.dart';

void main() {
  runApp(const FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          appBarTheme: const AppBarTheme(color: kPrimaryColor)),
      color: kPrimaryColor,
      home: const LoginWithName(),
    );
  }
}

class BluetoothManagement extends StatelessWidget {
  const BluetoothManagement({
    super.key,
    required this.name,
  });

  static String routeName = '/bluetooth';
  final String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          return FindDevicesScreen(
            name: name,
          );
        }
        return BluetoothOffScreen(state: state);
      },
    );
  }
}
