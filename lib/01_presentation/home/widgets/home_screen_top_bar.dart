import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../login/login.dart';

class HomeScreenTopBar extends StatelessWidget {
  const HomeScreenTopBar({
    super.key,
    required this.topRadius,
    required this.name,
  });

  final double topRadius;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kBackgroundColor,
      leading: Container(),
      expandedHeight: 100,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: kPrimaryColor.withOpacity(0.2),
                  offset: const Offset(10, 5),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      "Willkomen ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      "!",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset("assets/images/exo.png"),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      child: const Row(
                        children: [
                          Text(
                            'Logout ',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Icon(
                            Icons.logout,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginWithName(),
                          ),
                          (Route<dynamic> route) => false),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
