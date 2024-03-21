import 'package:flutter/material.dart';

import '../../02_application/exo_catch.dart';
import '../../02_application/exoskeleton.dart';
import '../../02_application/exoskeletongame.dart';
import '../../02_application/paths.dart';
import '../../constants.dart';
import '../Exoskeleton/widgets/exofullview.dart';
import '../Exoskeleton/widgets/exogame.dart';
import '../Exoskeleton/widgets/exoview.dart';

class MeasurementDetailPage extends StatefulWidget {
  const MeasurementDetailPage(
      {super.key, required this.readFileName, required this.name});
  final String readFileName;
  final String name;

  @override
  MeasurementDetailPageState createState() =>
      MeasurementDetailPageState(readFileName, name);
}

class MeasurementDetailPageState extends State<MeasurementDetailPage> {
  final String readFileName;
  final String name;

  List<String> content = [];
  bool isLoading = true;
  ExoskeletonAdv myExo = ExoskeletonAdv();
  ExoskeletonGame myExoGame = ExoskeletonGame();
  ExoskeletonCatch myExoCatch = ExoskeletonCatch();
  int lines = 2;
  int curLine = 1;
  double time = 0;
  int gameSwitch = 0;

  MeasurementDetailPageState(this.readFileName, this.name);

  @override
  initState() {
    super.initState();
    readContentLines(readFileName).then(
      (value) {
        content = value;
        lines = content.length;
        myExo.setParamsFromUser(name).then(
              (value) => {
                setState(
                  () {
                    List<int> intMessage =
                        contentLine2Message(content[curLine]);
                    updateCurTime(curLine);
                    setState(() {
                      myExo.update(intMessage);
                    });
                    isLoading = false;
                  },
                )
              },
            );
        myExoCatch.setConstParams(myExo);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(readFileName.split('/').last),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Center(child: Text('Lines: $lines')),
                    Stack(
                      children: [
                        gameSwitchScreen(),
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                gameSwitchIcon2(),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Spacer(),
                    Slider(
                      divisions: lines - 1,
                      label: 'Time: $time',
                      min: 1,
                      max: lines.toDouble() - 1,
                      value: curLine.toDouble(),
                      activeColor: kPrimaryColor,
                      onChanged: (double newValue) {
                        curLine = newValue.toInt();
                        List<int> intMessage =
                            contentLine2Message(content[curLine]);
                        updateCurTime(curLine);
                        setState(() {
                          myExo.update(intMessage);
                          if (gameSwitch == 1) {
                            myExoGame.update(myExo);
                          }
                          if (gameSwitch == 2) {
                            myExoCatch.update(myExo);
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget gameSwitchScreen() {
    if (gameSwitch == 0) {
      return ExoView(myExo: myExo);
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
        backgroundColor: Colors.grey.shade300.withOpacity(0),
        textStyle: const TextStyle(fontWeight: FontWeight.w200),
        minimumSize: const Size(100, 50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget gameSwitchIcon2() {
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

    return InkWell(
      onTap: () => setState(() {
        gameSwitch += 1;
        if (gameSwitch == 3) {
          gameSwitch = 0;
        }
      }),
      child: Row(
        children: [
          myIcon,
          const SizedBox(
            width: 5,
          ),
          myLabel,
        ],
      ),
    );
  }

  void updateCurTime(int curLine) {
    final int time0 = int.parse(content[1].split(';')[0]);
    time = (int.parse(content[curLine].split(';')[0]) - time0) / 1000;
  }
}

List<int> contentLine2Message(String contentLine) {
  return contentLine.split(';').map((e) => int.parse(e)).toList();
}
