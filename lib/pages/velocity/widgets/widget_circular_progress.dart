import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class AlertColorSpeed {
  double value;
  Color color;

  AlertColorSpeed(this.value, this.color);
}

class CircularPercentage extends StatefulWidget {
  final double? total;
  final double progress;
  final String text;
  final Color progressColor;
  final Color backgroundColor;
  final List<AlertColorSpeed>? listAlertSpeed;

  const CircularPercentage({
    super.key,
    this.total = 100,
    this.progress = 0,
    this.text = "",
    this.backgroundColor = Colors.black87,
    this.progressColor = Colors.green,
    this.listAlertSpeed,
  });

  @override
  State<CircularPercentage> createState() => _CircularPercentageState();
}

class _CircularPercentageState extends State<CircularPercentage> {
  GlobalKey<KdGaugeViewState> key = GlobalKey<KdGaugeViewState>();

  ValueNotifier<double> maxSpeed = ValueNotifier<double>(0);
  ValueNotifier<double> speed = ValueNotifier<double>(0);

  bool reassembleAux = false;
  var duration = const Duration(milliseconds: 400);

  @override
  void initState() {
    Future.delayed(duration, () {
      speed.addListener(() {
        key.currentState?.updateSpeed(
          widget.progress,
          animate: true,
          duration: duration,
        );
      });
      maxSpeed.addListener(() => key.currentState?.reassemble());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.progress;
    speed.value = widget.progress;
    maxSpeed.value = widget.total ?? 100.0;
    Color progressColor = widget.progressColor;
    List<AlertColorSpeed> listAlertSpeed = widget.listAlertSpeed ?? [];
    listAlertSpeed.sort((a, b) => a.value.compareTo(b.value)); //sort
    var list = listAlertSpeed.where((e) => progress <= e.value).toList();
    if (list.isNotEmpty) progressColor = list[0].color;
    return Stack(
      alignment: Alignment.center,
      children: [
        KdGaugeView(
          key: key,
          minSpeed: 0,
          maxSpeed: maxSpeed.value,
          speed: speed.value,
          animate: true,
          duration: duration,
          unitOfMeasurement: "",
          divisionCircleColors: Colors.transparent,
          subDivisionCircleColors: Colors.transparent,
          activeGaugeColor: progressColor,
          inactiveGaugeColor: widget.backgroundColor,
          minMaxTextStyle: const TextStyle(color: Colors.transparent),
          speedTextStyle: const TextStyle(
            color: Colors.transparent,
          ),
          gaugeWidth: 8.0,
          fractionDigits: 1,
        ),
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

Widget itemCardProgress({
  required String title,
  required String textCenter,
  double? total,
  required double progress,
  required Color colorProgress,
  List<AlertColorSpeed>? listAlertSpeed,
}) {
  return Card(
    child: Container(
      padding: const EdgeInsets.all(10.0).copyWith(
        bottom: 5.0,
        top: 5.0,
      ),
      height: 140.0,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15.0),
          Expanded(
            child: CircularPercentage(
              total: total,
              progress: progress,
              text: textCenter,
              progressColor: colorProgress,
              listAlertSpeed: listAlertSpeed,
            ),
          ),
        ],
      ),
    ),
  );
}
