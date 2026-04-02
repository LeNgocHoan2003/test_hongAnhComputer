import 'dart:ui';

import 'package:flutter/material.dart';

class HeaderCurveClipper extends CustomClipper<Path> {
  const HeaderCurveClipper({required this.curveHeight});

  final double curveHeight;

  @override
  Path getClip(Size size) {
    final baseY = 20.0;
    const horizontalInset = 30.0;
    final path = Path();

    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - baseY);
    final secondCurve = Offset(horizontalInset, size.height - baseY);
    path.quadraticBezierTo(
      firstCurve.dx,
      firstCurve.dy,
      secondCurve.dx,
      secondCurve.dy,
    );

    final thirdCurve = Offset(0, size.height - baseY);
    final fourthCurve = Offset(
      size.width - horizontalInset,
      size.height - baseY,
    );
    path.quadraticBezierTo(
      thirdCurve.dx,
      thirdCurve.dy,
      fourthCurve.dx,
      fourthCurve.dy,
    );

    final fifthCurve = Offset(size.width, size.height - baseY);
    final sixthCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(
      fifthCurve.dx,
      fifthCurve.dy,
      sixthCurve.dx,
      sixthCurve.dy,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant HeaderCurveClipper oldClipper) =>
      oldClipper.curveHeight != curveHeight;
}
