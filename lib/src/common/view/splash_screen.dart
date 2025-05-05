import 'dart:async';

import 'package:autis/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() async {
    // final prefs = await SharedPreferences.getInstance();
    // bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        GoRouter.of(context).go(
          RoutesNames.login,
        );
        // prefs.setBool('isFirstTime', false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00F1F8), // Light blue
              Color(0xFF0076BE), // Dark blue
            ],
          ),
        ),
        child: Center(
          child: Image(
            image: const AssetImage(Images.splashImage),
            width: 250.w, // Adjust as needed
            height: 250.h,
          ),
        ),
      ),
    );
  }
}
