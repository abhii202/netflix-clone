import 'package:flutter/material.dart';

class CurvedTextClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start earlier but keep a gentle slope
    path.moveTo(0, size.height * 0.63);

    // First curve — very gradual incline
    path.quadraticBezierTo(
      size.width * 0.18, // starts incline early
      size.height * 0.69, // gentle lift
      size.width * 0.5,
      size.height * 0.66, // midpoint slightly higher
    );

    // Second curve — matching slope for smoothness
    path.quadraticBezierTo(
      size.width * 0.82, // slightly farther right for balance
      size.height * 0.63, // close to previous Y for smooth join
      size.width,
      size.height * 0.28, // gradual rise to the end
    );

    // Close shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
