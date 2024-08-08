import 'package:app/main.dart';
import 'package:app/services/notification_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class Sensors extends StatefulWidget {
  final Color sinColor = Colors.blue;
  final Color cosColor = Colors.pink;
  
  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  int notTimes = 0;
  double x = 0;
  double y = 0;
  double z = 0;
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double X = 0;
  double step = .05;
  double threshold = 0.1;

  late Timer timer;
  bool isTimerRunning = false;
  late StreamSubscription<AccelerometerEvent> _accelerometer;

  void _initAccelerometer() {
     _accelerometer = accelerometerEvents.listen((AccelerometerEvent event) {
      if ((event.x - x).abs() > threshold ||
          (event.y - y).abs() > threshold ||
          (event.z - z).abs() > threshold) {
        if (!isTimerRunning) {
          _initTimer();
          isTimerRunning = true;
          if (notTimes == 2) {
            NotificationService.showBigTextNotification(
              title: 'Motion Detected',
              body: 'Some movement has been detected!',
              fln: flutterLocalNotificationsPlugin
            );
          }
          notTimes++;
        }
      } else {
        if (isTimerRunning) {
          timer.cancel();
          isTimerRunning = false;
        }
      }

      x = event.x;
      y = event.y;
      z = event.z;
      setState(() {});
    });
  }

  void _initTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(X, .5 * math.sin(20 * x) + .5 * math.sin(5 * y)));
        cosPoints.add(FlSpot(X, math.cos(x)));
      });
      X += step;
    });
  }

  @override
  void initState() {
    super.initState();
    _initAccelerometer();
  }

  @override
  void dispose() {
    if (isTimerRunning) {
      timer.cancel();
    }
    _accelerometer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'X: ${x.toStringAsFixed(4)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey, fontSize: 16, height: 1.6),
          ),
          Text(
            'Y: ${y.toStringAsFixed(4)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blue, fontSize: 16, height: 1.6),
          ),
          Text(
            'Z: ${z.toStringAsFixed(4)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 16, height: 1.6),
          ),
          SizedBox(height: 20),
          AspectRatio(
              aspectRatio: 1.5,
              child: sinPoints.isNotEmpty && isTimerRunning ?
                LineChart(LineChartData(
                  minY: -1,
                  maxY: 1,
                  minX: sinPoints.first.x,
                  maxX: sinPoints.last.x,
                  lineTouchData: LineTouchData(enabled: false),
                  clipData: FlClipData.all(),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    sinLine(sinPoints),
                    cosLine(cosPoints),
                  ],
                  titlesData: FlTitlesData(show: false),
                )
              ) : Container(),
            )
        ],
      ),
    );
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      gradient: LinearGradient(
        colors: [widget.sinColor.withOpacity(0), widget.sinColor],
        stops: const [.1, 1],
      ),
      barWidth: 5,
      isCurved: false,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      gradient: LinearGradient(
        colors: [widget.cosColor.withOpacity(0), widget.cosColor],
        stops: const [.1, 1],
      ),
      barWidth: 5,
      isCurved: false,
    );
  }
}
