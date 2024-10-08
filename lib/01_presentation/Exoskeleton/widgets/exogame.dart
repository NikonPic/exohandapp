import 'package:flutter/material.dart';

import '../../../02_application/exoskeletongame.dart';
import '../../../constants.dart';

class ExoGameView extends StatefulWidget {
  const ExoGameView({super.key, required this.myExoGame});
  final ExoskeletonGame myExoGame;

  @override
  ExoGameViewState createState() => ExoGameViewState(myExoGame);
}

class ExoGameViewState extends State<ExoGameView> {
  final ExoskeletonGame myExoGame;

  ExoGameViewState(this.myExoGame);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10)),
        height: 500,
        child: Stack(
          children: [
            CustomPaint(foregroundPainter: GamePainter(myExoGame)),
            ExoGameInfo(myExoGame: myExoGame),
            Column(children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      max: 100.0,
                      value: myExoGame.difficulty.toDouble(),
                      onChanged: (double newValue) {
                        setState(() => myExoGame.difficulty = newValue.ceil());
                        myExoGame.setDifficulty();
                      },
                      label: 'Difficulty: ${myExoGame.difficulty}',
                      activeColor: kPrimaryColor,
                      onChangeEnd: (double newValue) {
                        final SnackBar snackBar = SnackBar(
                            backgroundColor: kSecondaryColor.withOpacity(0.0),
                            elevation: 0,
                            content: SizedBox(
                              height: 70,
                              child: Column(
                                children: [
                                  Text(
                                    'Neuer Schwierigkeitsgrad: ${myExoGame.difficulty}',
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  ),
                                  Text(
                                    'Wahrscheinlichkeit Kugeln: ${myExoGame.friendProb / 10} %',
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  ),
                                  Text(
                                    'Wahrscheinlichkeit Rechtecke: ${myExoGame.enemyProb / 10} %',
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  ),
                                  Text(
                                    'Geschwindigkeit Feinde: ${myExoGame.enemyVel}',
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                ],
              )
            ])
          ],
        ),
      ),
    );
  }
}

class ExoGameInfo extends StatelessWidget {
  const ExoGameInfo({
    super.key,
    required this.myExoGame,
  });

  final ExoskeletonGame myExoGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Spacer(),
            Text(
              'Dein Score: ${myExoGame.score}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            SizedBox(width: 12),
            Text('Sammle: '),
            Icon(
              Icons.circle,
              color: Colors.redAccent,
              size: 15,
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            const Text('Vermeide: '),
            Container(width: 10, height: 10, color: Colors.black),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Spacer(),
            myExoGame.bonusActive
                ? Text(
                    '+ 100 Punkte',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:
                            Colors.black.withOpacity(myExoGame.bonusOpacity)),
                  )
                : const Text(''),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

class GamePainter extends CustomPainter {
  final ExoskeletonGame myExoGame;
  GamePainter(this.myExoGame);
  final double offx = 2;
  final double offy = 3;

  void drawEnemies(Canvas canvas) {
    final int numEnemies = myExoGame.enemy.myBlocks.length;
    if (numEnemies > 0) {
      for (int curEnemy = 0; curEnemy < numEnemies; curEnemy++) {
        final EnemyBlock curBlock = myExoGame.enemy.myBlocks[curEnemy];
        final paintEn = Paint()..color = curBlock.color;
        final shadowPaint = Paint()..color = curBlock.color.withOpacity(0.2);
        final Rect rect = Rect.fromLTRB(
            curBlock.topLeft.dx,
            curBlock.topLeft.dy,
            curBlock.bottomRight.dx,
            curBlock.bottomRight.dy);
        final Rect shadowRect = Rect.fromLTRB(
            curBlock.topLeft.dx + offx,
            curBlock.topLeft.dy + offy,
            curBlock.bottomRight.dx + offx,
            curBlock.bottomRight.dy + offy);
        canvas.drawRect(shadowRect, shadowPaint);
        canvas.drawRect(rect, paintEn);
      }
    }
  }

  void drawFriends(Canvas canvas) {
    final int numFriends = myExoGame.friend.myCircles.length;
    if (numFriends > 0) {
      for (int curFriend = 0; curFriend < numFriends; curFriend++) {
        final FriendRound curCircle = myExoGame.friend.myCircles[curFriend];
        final paintFr = Paint()..color = curCircle.color;
        canvas.drawCircle(Offset(curCircle.posX, curCircle.posY),
            curCircle.friendRad, paintFr);
      }
    }
  }

  void drawAvatar(Canvas canvas) {
    final paint = Paint()..color = Colors.amber;
    final paintSh = Paint()..color = Colors.amber.withOpacity(myExoGame.opaSh);

    canvas.drawCircle(Offset(myExoGame.posX, myExoGame.posY),
        myExoGame.avRad + myExoGame.opaRd, paintSh);

    canvas.drawCircle(
        Offset(myExoGame.posX, myExoGame.posY), myExoGame.avRad, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawEnemies(canvas);
    drawFriends(canvas);
    drawAvatar(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
