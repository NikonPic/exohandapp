import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oscilloscope/oscilloscope.dart';

import '../../constants.dart';
import '../DeviceScreen/device_screen.dart';
import '../FindDevicesScreen/find_devices_screen.dart';

// HM10-Controller: 001122

class MyOsciScreen extends StatelessWidget {
  final BluetoothCharacteristic myChar;
  final BluetoothDevice myDevice;
  final String name;

  static String routeName = "/my_osci_screen";

  const MyOsciScreen(
      {super.key,
      required this.myChar,
      required this.myDevice,
      required this.name});

  @override
  Widget build(BuildContext context) {
    myChar.setNotifyValue(true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(children: [
          InkWell(
            child: const Icon(Icons.arrow_back),
            onTap: () async {
              await myDevice.disconnect();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FindDevicesScreen(
                      name: name,
                    ),
                  ),
                  (route) => false);
            },
          ),
          const Spacer(),
          const Text('Sensor Data'),
          const Spacer(),
          InkWell(
            child: const Icon(Icons.info),
            onTap: () async {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(
                      'Press Start and review all 5 Sensors of this system.'),
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
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                OscillatorSensorScreen(
                  myChar: myChar,
                  select: 0,
                ),
                Row(
                  children: [
                    const Spacer(),
                    MyStyleButton(
                      myFunc: () async {
                        await _writeText(myChar, context, 'Start');
                      },
                      text: 'Start',
                    ),
                    SizedBox(
                      width: size.width * .5,
                    ),
                    MyStyleButton(
                      myFunc: () async {
                        await _writeText(myChar, context, 'Stop');
                      },
                      text: 'Stop',
                    ),
                    const Spacer(),
                  ],
                ),
              ],
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
              builder: (context) =>
                  MyOsciScreen(myChar: myChar, myDevice: myDevice, name: name),
            ),
            (route) => false),
      ),
    );
  }

  Future<void> _writeText(BluetoothCharacteristic characteristic,
      BuildContext context, String text) async {
    try {
      await characteristic.write(utf8.encode(text), withoutResponse: true);
      await Future.delayed(const Duration(milliseconds: 100));
      await characteristic.write(utf8.encode('$text$text'),
          withoutResponse: true);
      await Future.delayed(const Duration(milliseconds: 100));
      await characteristic.write(utf8.encode('$text$text$text'),
          withoutResponse: true);
      await Future.delayed(const Duration(milliseconds: 100));
      await characteristic.write(utf8.encode('$text$text$text$text'),
          withoutResponse: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$text sending failed'),
        ),
      );
    }
  }
}

class OscillatorSensorScreen extends StatefulWidget {
  const OscillatorSensorScreen({
    super.key,
    required this.myChar,
    required this.select,
  });

  @override
  OscillatorSensorScreenState createState() =>
      OscillatorSensorScreenState(myChar, select);

  final BluetoothCharacteristic myChar;
  final int select;
}

class OscillatorSensorScreenState extends State<OscillatorSensorScreen> {
  final BluetoothCharacteristic myChar;
  final int select;
  final int anzSensor = 5;
  final int buffer = 3;

  // the state wihin the widget
  int _minSensLength = 0;
  String hz = '';

  List<int> trace = [];
  List<int> sensCount = [0, 0, 0, 0, 0];
  String myLocString = '1';
  DateTime timeStart = DateTime.now();

  OscillatorSensorScreenState(this.myChar, this.select);

  // Transform local snapshot to String
  List<String> getCleanString(AsyncSnapshot<List<int>> snapshot) {
    List<String> returnData = snapshot.data
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(',', '')
        .split(' ');

    return returnData;
  }

  bool checkNewString(List<String> myString) {
    if (myString[0].isNotEmpty && myString.length == 20) {
      if (myString.sublist(0, 10).every((element) => element == '0')) {
        return false;
      }
      return checkSensorMatch(myString[0]);
    }
    return false;
  }

  bool checkSensorMatch(String byte0) {
    int sensor = getSensorIndex(byte0);

    // check and update sensor value
    if (sensCount[sensor] < _minSensLength + buffer) {
      sensCount[sensor] += 1;
      _minSensLength = sensCount.reduce(min);

      if (_minSensLength == 1) {
        timeStart = DateTime.now();
      }
      return true;
    }
    return false;
  }

  int getSensorData(String byte0, String byte1) {
    // transform to binary string and add running 0.
    String myLocString0 = (int.parse(byte0)).toRadixString(2).padLeft(8, '0');
    String myLocString1 = (int.parse(byte1)).toRadixString(2).padLeft(8, '0');
    String combStr = myLocString0 + myLocString1;
    int data = int.parse(combStr, radix: 2);

    return data;
  }

  int getSensorIndex(String byte0) {
    // transform to binary string and add running 0.
    myLocString = (int.parse(byte0)).toRadixString(2).padLeft(8, '0');
    // first 3 eles of binary to sensID
    int sensor = int.parse(myLocString.substring(0, 3), radix: 2);

    return sensor;
  }

  void addNewSnapData(AsyncSnapshot<List<int>> snapshot) {
    final List<String> myString = getCleanString(snapshot);

    // check if package can be accepted
    if (checkNewString(myString)) {
      // add current sensor value
      int sensor = getSensorIndex(myString[0]);
      trace.add(sensor);

      // get the frequency
      hz = (_minSensLength /
              (DateTime.now().difference(timeStart).inSeconds + 0.001))
          .toStringAsFixed(2);

      // update IMU Sensor data
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<int>>(
      stream: myChar.lastValueStream,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        addNewSnapData(snapshot);
        return Column(
          children: [
            SizedBox(
              width: size.width * .45,
              child: SizedBox(
                height: 50,
                child: Oscilloscope(
                  backgroundColor: kBackgroundColor,
                  dataSet: trace,
                  yAxisMax: 4,
                  yAxisMin: 0.0,
                  traceColor: kPrimaryColor.withOpacity(0.6),
                  strokeWidth: 2.0,
                  margin: const EdgeInsets.all(1),
                  onNewViewport: () {},
                ),
              ),
            ),
            Center(child: Text('Hz: $hz')),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
