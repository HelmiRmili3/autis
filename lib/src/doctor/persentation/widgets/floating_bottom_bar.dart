import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const FloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Slight blur/opacity
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w500,
                ),
            unselectedLabelStyle:
                Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w500,
                    ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
