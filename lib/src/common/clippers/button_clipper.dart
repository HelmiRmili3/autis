import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0); // Start above the bottom to make waves visible
    path.lineTo(0, 20); // Start above the bottom to make waves visible

    // Second wave
    // Create a perfect semicircular notch (demi cercle) starting from the bottom left
    const radius = 35.0;
    path.arcTo(
      Rect.fromCircle(center: Offset(22, size.height.h / 2), radius: radius.r),
      3.14,
      6.28,
      false,
    );

    // Complete the path
    path.lineTo(0, size.height); // Move to the right edge
    path.lineTo(size.width, size.height); // Move to the bottom right corner
    path.lineTo(size.width, 0); // Move to the bottom right corner

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) =>
      true; // Changed to true for dynamic resizing
}
