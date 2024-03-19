import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../constants.dart';
import '../home/home.dart';
import 'widgets/exozentral.dart';

// HM10-Controller: 001122

class ExoScreen extends StatelessWidget {
  final List<BluetoothCharacteristic> myChars;
  final BluetoothDevice myDevice;
  final String name;

  static String routeName = "/exo_screen";

  const ExoScreen(
      {super.key,
      required this.myChars,
      required this.myDevice,
      required this.name});

  @override
  Widget build(BuildContext context) {
    myChars[0].setNotifyValue(true);
    myChars[1].setNotifyValue(true);
    return Scaffold(
      appBar: buildDeviceAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ExoZentralScreen(
              myChars: myChars,
              name: name,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.refresh),
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ExoScreen(
                myChars: myChars,
                myDevice: myDevice,
                name: name,
              ),
            ),
            (route) => false),
      ),
    );
  }

  AppBar buildDeviceAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Row(children: [
        InkWell(
          child: const Icon(Icons.home),
          onTap: () async {
            await myDevice.disconnect();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    name: name,
                  ),
                ),
                (route) => false);
          },
        ),
        const Spacer(),
        const SizedBox(
          width: 20,
        ),
        const Text('Exoskelett'),
        const Spacer(),
      ]),
      actions: <Widget>[
        StreamBuilder<BluetoothDeviceState>(
          stream: myDevice.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (c, snapshot) {
            VoidCallback? onPressed;
            String text;
            Icon myIcon;
            switch (snapshot.data) {
              case BluetoothDeviceState.connected:
                onPressed = () => myDevice.disconnect();
                text = 'Verbunden';
                myIcon = const Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                );
                break;
              case BluetoothDeviceState.disconnected:
                onPressed = () =>
                    myDevice.connect().timeout(const Duration(seconds: 4));
                text = 'Nicht verbunden';
                myIcon = const Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.red,
                );
                break;
              default:
                onPressed = null;
                text = snapshot.data.toString().substring(21).toUpperCase();
                myIcon = const Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.red,
                );
                break;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: onPressed,
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  myIcon,
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
