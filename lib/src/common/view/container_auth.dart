import 'package:autis/src/common/containers/home_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerAuth extends StatelessWidget {
  final List<Widget> children;

  const ContainerAuth({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: HomeBg(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 650.h,
                        maxWidth: constraints.maxWidth,
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 20.h,
                      ),
                      color: Colors.transparent,
                      child: Stack(
                        children: children,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
