import 'package:autis/core/constants/images.dart';
import 'package:flutter/material.dart';

class HomeBg extends StatelessWidget {
  final Widget child;

  const HomeBg({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
