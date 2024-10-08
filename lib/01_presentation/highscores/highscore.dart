import 'dart:ui';

import 'package:flutter/material.dart';

import '../../02_application/paths.dart';
import '../MeasurementDetailPage/measurement_detail_page.dart';

class HighScorePage extends StatefulWidget {
  const HighScorePage({super.key, required this.name});
  final String name;

  @override
  HighScorePageState createState() => HighScorePageState(name);
}

class HighScorePageState extends State<HighScorePage> {
  final String name;

  HighScorePageState(this.name);

  List<String> fileNames = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    checkOrCreateuserDir(name).then(
      (value) => listAllNamesInDir(value).then(
        (value) => {
          setState(() {
            fileNames = value;
            isLoading = false;
          })
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Messungen von '),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: fileNames.length,
              itemBuilder: (context, index) => Column(
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(size.width * 0.8, 40),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    onPressed: () {
                      String readFileName =
                          '$name/${fileNames[index].replaceAll('.txt', '')}';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeasurementDetailPage(
                            readFileName: readFileName,
                            name: name,
                          ),
                        ),
                      );
                    },
                    child: Center(
                        child: Text(
                      fileNames[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ],
              ),
            ),
    );
  }
}

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  const GlassMorphism({
    super.key,
    required this.child,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(start),
                Colors.white.withOpacity(end),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
