import 'package:Clubzey/utils/match_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
class CustomContainer extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset(0,100) & Size(100, 100);
    double radius=100;
    int sides=4;

    var paint=Paint()..color=Color(0xFF909453);
    var path = Path();


//     Offset center = Offset(size.width / 2, size.height / 2);
//
// // startPoint => (100.0, 0.0)
//     Offset startPoint = Offset(radius * math.cos(0), radius * math.sin(0));
//
//     path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    path.lineTo(0,0);

    path.lineTo(0, 100);
    path.lineTo(100, 100);
    path.lineTo(120,0);
    path.arcToPoint(Offset(100,0),radius: Radius.circular(2), rotation: 100, clockwise: true);
    path.close();


    canvas.drawPath(


      path,
    paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}


class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(

        width: 100,
        height: 100,
        child: CustomPaint(

          painter: CustomContainer(),
        ),
      ),
    );
  }
}


