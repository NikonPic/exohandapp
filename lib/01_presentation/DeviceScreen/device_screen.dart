import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../constants.dart';
import '../Exoskeleton/exoscreen.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key, required this.device, required this.name});
  static String routeName = "/device_screen";
  final BluetoothDevice device;

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDeviceAppBar(context),
      body: StreamBuilder<BluetoothDeviceState>(
        stream: device.state,
        initialData: BluetoothDeviceState.connecting,
        builder: (BuildContext context,
            AsyncSnapshot<BluetoothDeviceState> snapshot) {
          Widget myWidget;
          switch (snapshot.data) {
            case BluetoothDeviceState.connected:
              myWidget = FutureBuilder(
                future: getChars(device),
                builder: (BuildContext context,
                    AsyncSnapshot<List<BluetoothCharacteristic>> charSnapshot) {
                  if (charSnapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          /*
                          MyStyleButton(
                            myFunc: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalibrationScreen(
                                            myChar: charSnapshot.data!,
                                            myDevice: device,
                                            name: name,
                                          )),
                                  (route) => false);
                            },
                            text: 'Perform Calibration',
                          ),
                          SizedBox(height: 20),
                          MyStyleButton(
                            myFunc: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyOsciScreen(
                                            myChar: charSnapshot.data!,
                                            myDevice: device,
                                            name: name,
                                          )),
                                  (route) => false);
                            },
                            text: 'View Sensor Details',
                          ),
                          SizedBox(height: 20),
                          */
                          MyStyleButton(
                            myFunc: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExoScreen(
                                      myChars: charSnapshot.data!,
                                      myDevice: device,
                                      name: name,
                                    ),
                                  ),
                                  (route) => false);
                            },
                            text: 'Exoskeleton',
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
              break;
            default:
              myWidget = const Center(
                child: Text('Not Connected'),
              );
              break;
          }
          return myWidget;
        },
      ),
    );
  }

  AppBar buildDeviceAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Text(device.name),
      actions: <Widget>[
        StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (c, snapshot) {
            VoidCallback? onPressed;
            String text;
            Icon myIcon;
            switch (snapshot.data) {
              case BluetoothDeviceState.connected:
                onPressed = () => device.disconnect();
                text = 'DISCONNECT';
                myIcon = const Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                );
                break;
              case BluetoothDeviceState.disconnected:
                onPressed =
                    () => device.connect().timeout(const Duration(seconds: 4));
                text = 'CONNECT';
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

Future<BluetoothCharacteristic> getSensorCharacteristic(
    BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  for (BluetoothService service in services) {
    if (service.uuid.toString() == "0000180a-0000-1000-8000-00805f9b34fb") {
      // Sensor service UUID
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() ==
            "00002a29-0000-1000-8000-00805f9b34fb") {
          // Sensor characteristic UUID
          return characteristic;
        }
      }
    }
  }
  throw Exception('Sensor characteristic not found');
}

Future<List<BluetoothCharacteristic>> getChars(BluetoothDevice mydevice) async {
  final List<BluetoothService> myServices = await mydevice.discoverServices();
  final BluetoothCharacteristic myChar = myServices[2].characteristics[0];
  final BluetoothCharacteristic myChar2 = myServices[3].characteristics[0];
  return [myChar, myChar2];
}

class MyStyleButton extends StatelessWidget {
  const MyStyleButton({
    super.key,
    required this.myFunc,
    required this.text,
  });
  final Function myFunc;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.grey.shade300,
        minimumSize: const Size(100, 50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: () {
        myFunc();
      },
      child: Text(text),
    );
  }
}
