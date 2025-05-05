import 'package:autis/src/common/clippers/button_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 50.h,
        child: Stack(children: [
          ClipPath(
            clipper: CustomButtonClipper(),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF00F1F8),
                        Color(0xFF0076BE),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25.r),
                      bottomRight: Radius.circular(25.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0, // Adjusted position
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                icon,
                color:
                    Colors.lightBlue, // Changed to white for better visibility
                size: 30.sp,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
