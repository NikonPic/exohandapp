import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oscilloscope/oscilloscope.dart';
import '../../../02_application/exoskeleton.dart';

class ExoView extends StatelessWidget {
  const ExoView({
    super.key,
    required this.myExo,
  });

  final ExoskeletonAdv myExo;
  final double yAxisRange = 200;
  final double mystroke = 2;
  final double myfonts = 15;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          AngleInfos(
              mystroke: mystroke,
              yAxisRange: yAxisRange,
              myExo: myExo,
              myfonts: myfonts),
          const SizedBox(height: 10),
          TorqueInfos(
              mystroke: mystroke,
              yAxisRange: 0.25,
              myExo: myExo,
              myfonts: myfonts),
          const SizedBox(height: 10),
          ForceView(
            mystroke: mystroke,
            myExo: myExo,
            myfonts: myfonts,
          )
        ],
      ),
    );
  }
}

class ExoViewHand extends StatelessWidget {
  const ExoViewHand({
    super.key,
    required this.myExo,
  });

  final ExoHand myExo;
  final double yAxisRange = 200;
  final double mystroke = 2;
  final double myfonts = 15;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AngleInfosExtend(
                fingerName: 'Index',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExo.indexData,
                myfonts: myfonts,
              ),
              AngleInfosExtend(
                fingerName: 'Middle',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExo.middleData,
                myfonts: myfonts,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AngleInfosExtend(
                fingerName: 'Ring',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExo.ringData,
                myfonts: myfonts,
              ),
              AngleInfosExtend(
                fingerName: 'Small',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExo.smallData,
                myfonts: myfonts,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ForceView extends StatelessWidget {
  const ForceView({
    super.key,
    required this.mystroke,
    required this.myExo,
    required this.myfonts,
  });

  final double mystroke;
  final Exoskeleton myExo;
  final double myfonts;
  final Color mycolor = Colors.deepPurpleAccent;
  final double yAxisMax = 10;
  final double yAxisMin = -10;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      height: 100,
      child: Stack(
        children: [
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: mycolor,
            yAxisMax: yAxisMax,
            yAxisMin: yAxisMin,
            dataSet: myExo.forceArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.forceArr = [],
            showYAxis: true,
          ),
          Row(
            children: [
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Force: ${myExo.force.toStringAsFixed(2)} N',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: myfonts,
                      color: mycolor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${yAxisMax.toInt()} [N]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Text(
                    '${yAxisMin.toInt()} [N]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AngleInfos extends StatelessWidget {
  const AngleInfos({
    super.key,
    required this.mystroke,
    required this.yAxisRange,
    required this.myExo,
    required this.myfonts,
  });

  final double mystroke;
  final double yAxisRange;
  final Exoskeleton myExo;
  final double myfonts;

  @override
  Widget build(BuildContext context) {
    final double yAxisMax = yAxisRange;
    final double yAxisMin = -yAxisRange;
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      height: 200,
      child: Stack(
        children: [
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.amber,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myExo.degBarr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.degBarr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.blue,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myExo.degAarr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.degAarr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.red,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myExo.degKarr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.degKarr = [],
            showYAxis: true,
          ),
          Row(
            children: [
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Angle MCP: ${getvalue(myExo.degB)} °',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: myfonts,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    'Angle PIP: ${getvalue(myExo.degA)} °',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.blue),
                  ),
                  Text(
                    'Angle DIP: ${getvalue(myExo.degK)} °',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.red),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${yAxisMax.toInt()} [°]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Text(
                    '${yAxisMin.toInt()} [°]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AngleInfosExtend extends StatelessWidget {
  const AngleInfosExtend({
    super.key,
    required this.fingerName,
    required this.mystroke,
    required this.yAxisRange,
    required this.myFinger,
    required this.myfonts,
  });

  final String fingerName;
  final double mystroke;
  final double yAxisRange;
  final FingerData myFinger;
  final double myfonts;

  @override
  Widget build(BuildContext context) {
    final double yAxisMax = yAxisRange;
    final double yAxisMin = -yAxisRange;
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      height: 200,
      width: size.width * 0.45,
      child: Stack(
        children: [
          Column(
            children: [
              const Spacer(),
              Text(
                fingerName,
                style: const TextStyle(fontWeight: FontWeight.w200),
              ),
            ],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: const Color.fromARGB(255, 252, 189, 1),
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myFinger.angleNArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.angleNArr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.blue,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myFinger.angleBArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.angleBArr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.red,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myFinger.angleAArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.angleAArr = [],
            showYAxis: true,
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: const Color.fromARGB(255, 13, 59, 15),
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myFinger.angleKArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.angleKArr = [],
          ),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${yAxisMax.toInt()} [°]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Text(
                    '${yAxisMin.toInt()} [°]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  Text(
                    'N: ${myFinger.angleN} °',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: myfonts,
                      color: const Color.fromARGB(255, 153, 116, 6),
                    ),
                  ),
                  Text(
                    'B: ${myFinger.angleB} °',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: myfonts,
                        color: Colors.blue),
                  ),
                  Text(
                    'A: ${myFinger.angleA} °',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: myfonts,
                        color: Colors.red),
                  ),
                  Text(
                    'K: ${myFinger.angleK} °',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: myfonts,
                      color: const Color.fromARGB(255, 13, 59, 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 70,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TorqueInfos extends StatelessWidget {
  const TorqueInfos({
    super.key,
    required this.mystroke,
    required this.yAxisRange,
    required this.myExo,
    required this.myfonts,
  });

  final double mystroke;
  final double yAxisRange;
  final ExoskeletonAdv myExo;
  final double myfonts;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      height: 200,
      child: Stack(
        children: [
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.amber,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myExo.mMcpNmArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.mMcpNmArr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.blue,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myExo.mPipNmArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.mPipNmArr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.red,
            yAxisMax: yAxisRange,
            yAxisMin: -yAxisRange,
            dataSet: myExo.mDipNmArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.mDipNmArr = [],
            showYAxis: true,
          ),
          Row(
            children: [
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Torque MCP: ${getvalue(myExo.mMcpNmm) / 1000} Nm',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: myfonts,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    'Torque PIP: ${getvalue(myExo.mPipNmm) / 1000} Nm',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.blue),
                  ),
                  Text(
                    'Torque DIP: ${getvalue(myExo.mDipNmm) / 1000} Nm',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.red),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '$yAxisRange [Nm]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Text(
                    '${-yAxisRange} [Nm]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

int getvalue(double value) {
  if (value.isInfinite || value.isNaN) {
    return 0;
  }
  return value.toInt();
}
