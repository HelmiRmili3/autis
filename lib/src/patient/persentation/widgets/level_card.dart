import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelCard extends StatelessWidget {
  final int level;
  final String image;
  final VoidCallback onPressed;
  const LevelCard({
    super.key,
    required this.level,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 55.h,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Text(
                    level.toString(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(
                        0.7,
                      ),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
