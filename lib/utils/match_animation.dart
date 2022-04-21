import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Polygon extends StatefulWidget {
  final Color color;
  final double initialValue;

  const Polygon({Key? key, required this.color, required this.initialValue}) : super(key: key);
  @override
  _PolygonState createState() => _PolygonState();
}

class _PolygonState extends State<Polygon> with SingleTickerProviderStateMixin {


  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,

      duration: Duration(milliseconds: 800 ),
    );
    _controller.value = widget.initialValue;
    _controller.forward();
    _controller.addListener(() {
      if(_controller.isCompleted){
        _controller.value = widget.initialValue;
        _controller.forward();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, snapshot) {
              return Center(
                child: CustomPaint(
                  painter: PolygonPainter(

                    progress: _controller.value, color: widget.color,

                  ),
                ),
              );
            }),
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
final Color color;


  final double progress;


  final Paint _paint = Paint()
    ..color = Colors.purple
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  PolygonPainter({required this.progress,required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPath(4, 62);
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath =
    pathMetric.extractPath(0, pathMetric.length * progress);
    _paint.color=color;
    canvas.rotate(90.323);
      canvas.drawPath(extractPath, _paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path createPath(int sides, double radius) {
    var path = Path();
    var angle = (math.pi * 2) / sides;

    path.moveTo(radius * math.cos(0.0), radius * math.sin(0.0));
    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i);
      double y = radius * math.sin(angle * i);
      path.lineTo(x, y);
    }
    path.close();
    
    return path;
  }
}