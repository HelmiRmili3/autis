import 'package:flutter/material.dart';

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height); // Start above the bottom to make waves visible

    // Second wave
    // Create a perfect semicircular notch (demi cercle) starting from the bottom left
    const radius = 50.0;
    path.arcTo(
      Rect.fromCircle(center: Offset(radius, size.height), radius: radius),
      3.14,
      3.14,
      false,
    );

    // Complete the path
    path.lineTo(size.width - 100, size.height); // Move to the right edge
    path.arcTo(
      Rect.fromCircle(
          center: Offset(size.width - radius, size.height), radius: radius),
      3.14,
      3.14,
      false,
    );

    path.lineTo(size.width, 0); // Move to the bottom right corner
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) =>
      true; // Changed to true for dynamic resizing
}
