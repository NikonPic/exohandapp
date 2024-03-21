import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../02_application/exo_catch.dart';
import '../../../02_application/exoskeleton.dart';
import '../../../02_application/exoskeletongame.dart';
import '../../../02_application/paths.dart';
import '../../DeviceScreen/device_screen.dart';
import 'exofullview.dart';
import 'exogame.dart';
import 'exoview.dart';

class ExoZentralScreen extends StatefulWidget {
  const ExoZentralScreen({
    super.key,
    required this.myChars,
    required this.name,
  });

  @override
  ExoZentralScreenState createState() => ExoZentralScreenState(myChars, name);

  final List<BluetoothCharacteristic> myChars;
  final String name;
}

class ExoZentralScreenState extends State<ExoZentralScreen> {
  final List<BluetoothCharacteristic> myChars;
  final String name;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    refreshUser();
    myExoCatch.setConstParams(myExo);
    myChars[1].setNotifyValue(true);
  }

  Future refreshUser() async {
    await myExo.setParamsFromUser(name);
    setState(() {
      isLoading = false;
    });
  }

  // the state wihin the widget
  String hz = '';
  double msOld = 0;

  List<int> trace = [];
  String myLocString = '1';
  DateTime timeStart = DateTime.now();
  ExoskeletonAdv myExo = ExoskeletonAdv();
  ExoHand myHand = ExoHand();
  ExoskeletonGame myExoGame = ExoskeletonGame();
  ExoskeletonCatch myExoCatch = ExoskeletonCatch();
  int gameSwitch = 0;

  ExoZentralScreenState(this.myChars, this.name);

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

  List<int> allSensorData(List<String> returnData) {
    int ms = getSensorData(returnData[0], returnData[1]);
    int angleB = getSensorData(returnData[2], returnData[3]);
    int angleA = getSensorData(returnData[4], returnData[5]);
    int angleK = getSensorData(returnData[6], returnData[7]);
    int forceB = getSensorData(returnData[8], returnData[9]);
    int forceA = getSensorData(returnData[10], returnData[11]);
    return [ms, angleB, angleA, angleK, forceB, forceA];
  }

  List<int> allSensorDataBig(List<String> returnData) {
    // index finger
    int angleNI = getSensorData(returnData[0], returnData[1]);
    int angleBI = getSensorData(returnData[2], returnData[3]);
    int angleAI = getSensorData(returnData[4], returnData[5]);
    int angleKI = getSensorData(returnData[6], returnData[7]);
    // middle finger
    int angleNM = getSensorData(returnData[8], returnData[9]);
    int angleBM = getSensorData(returnData[10], returnData[11]);
    int angleAM = getSensorData(returnData[12], returnData[13]);
    int angleKM = getSensorData(returnData[14], returnData[15]);
    // ring finger
    int angleNR = getSensorData(returnData[16], returnData[17]);
    int angleBR = getSensorData(returnData[18], returnData[19]);
    int angleAR = getSensorData(returnData[20], returnData[21]);
    int angleKR = getSensorData(returnData[22], returnData[23]);
    // small finger
    int angleNS = getSensorData(returnData[24], returnData[25]);
    int angleBS = getSensorData(returnData[26], returnData[27]);
    int angleAS = getSensorData(returnData[28], returnData[29]);
    int angleKS = getSensorData(returnData[30], returnData[31]);
    //forces
    int forceI = getSensorData(returnData[32], returnData[33]);
    int forceM = getSensorData(returnData[34], returnData[35]);
    int forceR = getSensorData(returnData[36], returnData[37]);
    int forceS = getSensorData(returnData[38], returnData[39]);
    //centiseconds
    int cs = getSensorData(returnData[40], returnData[41]);
    return [
      cs,
      angleNI,
      angleBI,
      angleAI,
      angleKI,
      angleNM,
      angleBM,
      angleAM,
      angleKM,
      angleNR,
      angleBR,
      angleAR,
      angleKR,
      angleNS,
      angleBS,
      angleAS,
      angleKS,
      forceI,
      forceM,
      forceR,
      forceS
    ];
  }

  int getSensorData(String byte0, String byte1) {
    // Convert byte strings to integers
    int b0 = int.parse(byte0);
    int b1 = int.parse(byte1);

    // Combine the two bytes. Assume little-endian order by default.
    // Adjust if your system uses a different endianness.
    int combined = b0 | (b1 << 8);

    // Check if the combined integer represents a negative value
    if ((combined & 0x8000) != 0) {
      // If yes, convert from two's complement to negative int
      combined = combined - 0x10000;
    }

    return combined;
  }

  int getSensorIndex(String byte0) {
    // transform to binary string and add running 0.
    myLocString = (int.parse(byte0)).toRadixString(2).padLeft(8, '0');
    // first 3 eles of binary to sensID
    int sensor = int.parse(myLocString.substring(0, 3), radix: 2);

    return sensor;
  }

  void addNewSnapData(AsyncSnapshot<List<int>> snapshot) async {
    final List<String> returnData = getCleanString(snapshot);

    if (returnData.length == 80) {
      final List<int> message = allSensorDataBig(returnData);
      double msNew = message.first.toDouble();
      int hzInt = (100 / max(msNew - msOld, 1.0)).ceil();
      trace.add(hzInt);
      int sum = trace.fold(0, (p, c) => p + c);
      int avHz = (sum / trace.length).ceil().toInt();
      hz = avHz.toString();
      msOld = msNew;
      myHand.update(message);
      if (gameSwitch == 1) {
        if (myExoGame.update(myExo)) {
          await _writeText(myChars[0], context, 'Stop');
        }
      }
      if (gameSwitch == 2) {
        myExoCatch.update(myExo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isLoading
            ? const CircularProgressIndicator()
            : StreamBuilder<List<int>>(
                stream: myChars[1].lastValueStream,
                builder:
                    (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                  addNewSnapData(snapshot);
                  return Column(
                    children: [
                      const SizedBox(
                        height: 60,
                        child: Row(
                          children: [Spacer(), SizedBox(width: 20)],
                        ),
                      ),
                      Center(
                        child: Text(
                          'Hz: $hz',
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          gameSwitchScreen(),
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  gameSwitchIcon(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                },
              ),
        myControlButtons(context),
      ],
    );
  }

  Widget myControlButtons(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        MyStyleButton(
          myFunc: () async {
            await _writeText(myChars[0], context, 'Start');
          },
          text: 'Messen + Motor',
        ),
        const Spacer(),
        MyStyleButton(
          myFunc: () async {
            await _writeText(myChars[0], context, 'Game');
          },
          text: 'Messen',
        ),
        const Spacer(),
        MyStyleButton(
          myFunc: () async {
            await _writeText(myChars[0], context, 'Stop');
            // save the recieved file
            if (myExo.degAarr.isNotEmpty) {
              String fileName = await getPossibleMeasurementName(name);
              String lastPart = fileName.split('/').last;
              lastPart = lastPart.split('.').first;
              AlertDialog myDialog = AlertDialog(
                title: const Text('Save Measurement?'),
                content: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Gib den Namen der Messung an',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    fileName = '$name/$value';
                  },
                  initialValue: lastPart,
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await myExo.save(fileName);
                      Navigator.pop(context, true);
                      SnackBar snackBar = SnackBar(
                        content: Text('Gespeichert unter $fileName'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Ja'),
                  ),
                  TextButton(
                    onPressed: () => {Navigator.pop(context, false)},
                    child: const Text('Nein'),
                  ),
                ],
                elevation: 24,
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return myDialog;
                },
              );
            }
          },
          text: 'Stop',
        ),
        const Spacer(),
      ],
    );
  }

  Widget gameSwitchScreen() {
    if (gameSwitch == 0) {
      return ExoViewHand(myExo: myHand);
    }
    if (gameSwitch == 1) {
      return ExoGameView(myExoGame: myExoGame);
    }
    return ExoFullView(
      myExo: myExo,
      name: name,
      myExoGame: myExoCatch,
      measurementMode: false,
    );
  }

  ElevatedButton gameSwitchIcon() {
    Icon myIcon = const Icon(
      Icons.science,
      size: 15,
    );
    Text myLabel = const Text('Measure Mode');
    if (gameSwitch == 1) {
      myIcon = const Icon(
        Icons.gamepad,
        size: 15,
      );
      myLabel = const Text('Game Mode');
    }
    if (gameSwitch == 2) {
      myIcon = const Icon(
        Icons.panorama_fish_eye,
        size: 15,
      );
      myLabel = const Text('View Mode');
    }

    return ElevatedButton.icon(
      onPressed: () => setState(() {
        gameSwitch += 1;
        if (gameSwitch == 3) {
          gameSwitch = 0;
        }
      }),
      icon: myIcon,
      label: myLabel,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.grey.shade300.withOpacity(0.5),
        textStyle: const TextStyle(fontWeight: FontWeight.w200),
        shadowColor: Colors.white.withOpacity(0),
        minimumSize: const Size(100, 50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

Future<void> _writeText(BluetoothCharacteristic characteristic,
    BuildContext context, String text) async {
  try {
    await characteristic.write(utf8.encode(text));
    await Future.delayed(const Duration(milliseconds: 100));
    await characteristic.write(utf8.encode('$text$text'));
    await Future.delayed(const Duration(milliseconds: 100));
    await characteristic.write(utf8.encode('$text$text$text'));
    await Future.delayed(const Duration(milliseconds: 100));
    await characteristic.write(utf8.encode('$text$text$text$text'));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text sending failed'),
      ),
    );
  }
}
