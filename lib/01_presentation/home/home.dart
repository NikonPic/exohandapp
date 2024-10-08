// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';

import '../../main.dart';
import '../Questionnaires/question_screen.dart';
import '../UserInformation/user_information.dart';
import '../highscores/highscore.dart';
import 'widgets/home_screen_card.dart';
import 'widgets/home_screen_top_bar.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/AsanaHome';
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final double topRadius = 30;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeScreenTopBar(
            topRadius: topRadius,
            name: name,
          ),
          HomeScreenCards(name: name),
        ],
      ),
    );
  }
}

class HomePageContent {
  final String title;
  final String subtitle;
  final String assetSrc;
  final Color color;
  final Function func;

  HomePageContent({
    required this.title,
    required this.assetSrc,
    required this.func,
    this.subtitle = '',
    this.color = Colors.white,
  });
}

List<HomePageContent> myHomePageList = [
  HomePageContent(
    title: "Exoskelett",
    subtitle: "Messe und spiele mit dem Exoskelett",
    assetSrc: "assets/images/realExo.png",
    func: (BuildContext context, String name) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BluetoothManagement(
            name: name,
          ),
        ),
      );
    },
  ),
  HomePageContent(
    title: "Messungen",
    subtitle: "Betrachte die vorgenommenen Messungen im Detail",
    assetSrc: "assets/images/measure.jpg",
    func: (BuildContext context, String name) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HighScorePage(
            name: name,
          ),
        ),
      );
    },
  ),
  HomePageContent(
    title: "Parameter Angabe",
    subtitle: "Gib deine individuellen Parameter an",
    assetSrc: "assets/images/path1628.png",
    func: (BuildContext context, String name) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInformation(
            name: name,
          ),
        ),
      );
    },
  ),
  HomePageContent(
      title: "Fragebögen",
      subtitle: "Beantworte Fragen zu deinem Befinden",
      assetSrc: "assets/images/question.webp",
      func: (BuildContext context, String name) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionScreen(
              name: name,
            ),
          ),
        );
      }),
];
