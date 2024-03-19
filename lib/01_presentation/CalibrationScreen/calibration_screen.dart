import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../constants.dart';
import '../FindDevicesScreen/find_devices_screen.dart';
import 'widgets/info_text.dart';

class CalibrationScreen extends StatelessWidget {
  final BluetoothDevice myDevice;
  final BluetoothCharacteristic myChar;
  final String name;

  const CalibrationScreen(
      {super.key,
      required this.myDevice,
      required this.myChar,
      required this.name});

  @override
  Widget build(BuildContext context) {
    myChar.setNotifyValue(true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          children: [
            InkWell(
              child: const Icon(Icons.arrow_back),
              onTap: () async {
                await myDevice.disconnect();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindDevicesScreen(name: name),
                    ),
                    (route) => false);
              },
            ),
            const Spacer(),
            const Text('Perform Calibration'),
            const Spacer(),
            InkWell(
              child: const Icon(Icons.info),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const CalibInfoText(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CalibInfoText(),
            ],
          ),
        ),
      ),
    );
  }
}
