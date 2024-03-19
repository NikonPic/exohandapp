import 'package:flutter/material.dart';

import '../home.dart';

class HomeScreenCards extends StatelessWidget {
  const HomeScreenCards({
    super.key,
    required this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
          _buildList(myHomePageList, name) as List<Widget>),
    );
  }
}

class HomeScreenCard extends StatelessWidget {
  const HomeScreenCard({
    super.key,
    required this.element,
    required this.name,
  });
  final HomePageContent element;
  final String name;

  @override
  Widget build(BuildContext context) {
    const double radius = 10;
    const double height = 200;
    final Size size = MediaQuery.of(context).size;
    final double width = size.width * 0.9;

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            element.func(context, name);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(radius),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.3),
                )
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(radius)),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade400,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(radius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(5, 5),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.5),
                        )
                      ],
                    ),
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(element.assetSrc),
                    ),
                  ),
                ),
                Container(
                  height: height,
                  width: width,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        element.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 5),
                            )
                          ],
                        ),
                      ),
                      Text(
                        element.subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 5),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

List _buildList(List<HomePageContent> myList, String name) {
  List<Widget> listItems = [];

  for (var element in myList) {
    listItems.add(
      HomeScreenCard(
        element: element,
        name: name,
      ),
    );
  }

  return listItems;
}
