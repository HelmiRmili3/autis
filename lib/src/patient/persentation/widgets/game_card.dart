import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String levels;
  final VoidCallback onPressed;
  final double rating;
  final Color primaryColor = const Color(0xFF0076BE);
  final Color accentColor = const Color(0xFF00F1F8);

  const GameCard({
    super.key,
    required this.title,
    required this.levels,
    required this.onPressed,
    this.rating = 4.5,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onPressed,
            splashColor: accentColor.withOpacity(0.2),
            highlightColor: accentColor.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Game icon placeholder (could be replaced with actual game icon)
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.games,
                      size: 30.w,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Game title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Rating
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Icon(
                  //       Icons.star,
                  //       size: 16.w,
                  //       color: Colors.amber,
                  //     ),
                  //     SizedBox(width: 4.w),
                  //     Text(
                  //       rating.toStringAsFixed(1),
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         color: Colors.black54,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Play button
                  SizedBox(
                    height: 40.h,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, accentColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'PLAY NOW',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
