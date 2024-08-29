import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import '../../../02_application/exoskeleton.dart';

class ExoView extends StatelessWidget {
  const ExoView({
    super.key,
    required this.myExoList,
  });

  final List<ExoskeletonAdv> myExoList;
  final double yAxisRange = 200;
  final double mystroke = 2;
  final double myfonts = 15;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AngleInfos(
            mystroke: mystroke,
            yAxisRange: yAxisRange,
            myExo: myExoList[0],
            myfonts: myfonts),
        const SizedBox(height: 10),
        TorqueInfos(
            mystroke: mystroke,
            yAxisRange: 0.25,
            myExo: myExoList[0],
            myfonts: myfonts),
        const SizedBox(height: 10),
        ForceView(
          mystroke: mystroke,
          myExo: myExoList[0],
          myfonts: myfonts,
        )
      ],
    );
  }
}

class ExoViewHand extends StatelessWidget {
  ExoViewHand({
    super.key,
    required this.myExoHand,
    required this.myExoList,
  });

  final ExoHand myExoHand;
  final List<ExoskeletonAdv> myExoList;
  final List<double> yAxisRange = [-40, 220];
  final double mystroke = 2;
  final double myfonts = 15;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AngleInfosFinger(
                fingerName: 'Index',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExoList[0],
                myfonts: myfonts,
              ),
              AngleInfosFinger(
                fingerName: 'Middle',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExoList[1],
                myfonts: myfonts,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AngleInfosFinger(
                fingerName: 'Ring',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExoList[2],
                myfonts: myfonts,
              ),
              AngleInfosFinger(
                fingerName: 'Small',
                mystroke: mystroke,
                yAxisRange: yAxisRange,
                myFinger: myExoList[3],
                myfonts: myfonts,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ForceInfos(
              myExoList: myExoList,
              mystroke: mystroke,
              yAxisRange: const [-5, 10],
              myExo: myExoHand,
              myfonts: myfonts)
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
      height: 150,
      width: size.width * 0.49,
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

class ForceInfos extends StatelessWidget {
  const ForceInfos({
    super.key,
    required this.mystroke,
    required this.yAxisRange,
    required this.myExo,
    required this.myfonts,
    required this.myExoList,
  });

  final double mystroke;
  final List<double> yAxisRange;
  final ExoHand myExo;
  final List<ExoskeletonAdv> myExoList;
  final double myfonts;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      height: 150,
      child: Stack(
        children: [
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.amber,
            yAxisMax: yAxisRange[1],
            yAxisMin: yAxisRange[0],
            dataSet: myExoList[0].forceArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.indexData.forceArr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.blue,
            yAxisMax: yAxisRange[1],
            yAxisMin: yAxisRange[0],
            dataSet: myExoList[1].forceArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.middleData.forceArr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.red,
            yAxisMax: yAxisRange[1],
            yAxisMin: yAxisRange[0],
            dataSet: myExoList[2].forceArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.ringData.forceArr = [],
            showYAxis: true,
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.purple,
            yAxisMax: yAxisRange[1],
            yAxisMin: yAxisRange[0],
            dataSet: myExoList[3].forceArr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myExo.smallData.forceArr = [],
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
                    'index: ${myExoList[0].force.toStringAsFixed(3)} N',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: myfonts,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    'middle: ${myExoList[1].force.toStringAsFixed(3)} N',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.blue),
                  ),
                  Text(
                    'ring: ${myExoList[2].force.toStringAsFixed(3)} N',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.red),
                  ),
                  Text(
                    'small: ${myExoList[3].force.toStringAsFixed(3)} N',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: myfonts,
                        color: Colors.purple),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${yAxisRange[1]} [N]',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: myfonts,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Text(
                    '${yAxisRange[0]} [N]',
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

class AngleInfosFinger extends StatelessWidget {
  const AngleInfosFinger({
    super.key,
    required this.fingerName,
    required this.mystroke,
    required this.yAxisRange,
    required this.myFinger,
    required this.myfonts,
  });

  final String fingerName;
  final double mystroke;
  final List<double> yAxisRange;
  final ExoskeletonAdv myFinger;
  final double myfonts;

  @override
  Widget build(BuildContext context) {
    final double yAxisMax = yAxisRange[1];
    final double yAxisMin = yAxisRange[0];
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      height: 150,
      width: size.width * 0.49,
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
            yAxisMax: yAxisMax,
            yAxisMin: yAxisMin,
            dataSet: myFinger.degBarr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.degBarr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.blue,
            yAxisMax: yAxisMax,
            yAxisMin: yAxisMin,
            dataSet: myFinger.degAarr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.degAarr = [],
          ),
          Oscilloscope(
            strokeWidth: mystroke,
            traceColor: Colors.red,
            yAxisMax: yAxisMax,
            yAxisMin: yAxisMin,
            dataSet: myFinger.degKarr,
            backgroundColor: Colors.black.withOpacity(0),
            onNewViewport: () => myFinger.degKarr = [],
            showYAxis: true,
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
                    'MCP: ${myFinger.phiMCP.toInt().abs()} °',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: myfonts,
                      color: const Color.fromARGB(255, 153, 116, 6),
                    ),
                  ),
                  Text(
                    'PIP: ${myFinger.phiPIP.toInt().abs()} °',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: myfonts,
                        color: Colors.blue),
                  ),
                  Text(
                    'DIP: ${myFinger.phiDIP.toInt().abs()} °',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: myfonts,
                        color: Colors.red),
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
