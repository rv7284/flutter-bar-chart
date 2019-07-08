import 'package:flutter/material.dart';
import 'dart:math';

class BarChartValue {
  final double value;
  BarChartValue({@required this.value});
}

class BarChart extends StatefulWidget {
  final List<BarChartValue> values;

  const BarChart({@required this.values});

  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60.0,
        child: CustomPaint(
          painter: BarPainter(readings: widget.values, color: Colors.pink),
        ),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final Color color;
  final List<BarChartValue> readings;
  final double gap = 6.0;

  BarPainter({this.color = Colors.black, @required this.readings});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    double totalHeight = size.height;
    double totalWidth = size.width;
    double barWidth =
        (totalWidth - ((readings.length - 1) * gap)) / readings.length;

    double maxReading = readings.map((v) => v.value).toList().reduce(max);
    double average =
        readings.map((v) => v.value).toList().reduce((a, b) => a + b) /
            readings.length;

    double chartMinVlaue = 0;

    double range = maxReading - chartMinVlaue;
    double startPoint = 0;

    for (var reading in readings) {
      double portion = ((reading.value - chartMinVlaue) / range);
      double barHeight = totalHeight * portion;

      line.color = reading.value <= average ? color.withAlpha(100) : color;

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  startPoint, totalHeight - barHeight, barWidth, barHeight),
              Radius.circular(3.0)),
          line);
      startPoint += barWidth + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
