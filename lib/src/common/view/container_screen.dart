import 'package:autis/src/common/containers/home_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../clippers/app_bar_clipper.dart';

class ContainerScreen extends StatelessWidget {
  final String title;
  final IconData? leadingicon;
  final IconData? trailingIcon;
  final String imagePath;
  final VoidCallback? onTrailingPress; // Changed from onClick to VoidCallback
  final VoidCallback? onLeadingPress; // Changed from onClick to VoidCallback
  final List<Widget> children;
  final Widget? floatingActionButton;

  const ContainerScreen({
    super.key,
    required this.title,
    this.leadingicon,
    this.trailingIcon,
    required this.imagePath,
    this.onTrailingPress,
    this.onLeadingPress,
    required this.children,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    int appbarHeight = 100;
    return Scaffold(
      body: HomeBg(
        child: Stack(
          children: [
            // Costom clipped background
            ClipPath(
              clipper: CustomAppBarClipper(),
              child: Container(
                height: appbarHeight.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF00F1F8),
                      Color(0xFF0076BE),
                    ],
                  ),
                ),
              ),
            ),
            // AppBar with a gradient background
            Positioned(
              top: (appbarHeight - 40).h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  IconButton(
                    icon: Icon(
                      leadingicon,
                      color: Colors.white,
                    ), // Fixed: connected to the prop
                    iconSize: 26.sp,
                    onPressed: onLeadingPress,
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  SizedBox(
                    width: 170.w,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  IconButton(
                    icon: Icon(
                      trailingIcon,
                      color: Colors.white,
                    ),
                    iconSize: 26.sp,
                    onPressed: onTrailingPress, // Fixed: connected to the prop
                  ),
                ],
              ),
            ),
            // Content of the screen
            Positioned(
              top: (appbarHeight).h,
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
              child: SingleChildScrollView(
                child: Container(
                  height: 650.h,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
