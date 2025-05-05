import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/src/common/blocs/game_bloc/game_bloc.dart';
import 'package:autis/src/common/blocs/game_bloc/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/game_bloc/game_event.dart';
import '../../../common/view/container_screen.dart';
import '../widgets/game_card.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    sl<GameBloc>().add(GetGames(null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      if (state is GameLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is GameFailure) {
        return Center(
          child: Text(state.error),
        );
      }

      if (state is GamesLoaded) {
        return ContainerScreen(
          title: Strings.games,
          imagePath: 'assets/images/homebg.png',
          trailingIcon: Icons.settings,
          onTrailingPress: () {
            sl<NavigationService>().pushNamed(
              RoutesNames.settings,
            );
          },
          children: [
            SizedBox(
              height: 650.h,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                padding: EdgeInsets.all(16.w),
                childAspectRatio: 0.7,
                children: state.games
                    .map((game) => GameCard(
                          title: game.name,
                          levels: '${game.levels.length} levels',
                          onPressed: () {
                            sl<NavigationService>().pushNamed(
                              RoutesNames.game,
                              extra: game,
                            );
                          },
                        ))
                    .toList(),
              ),
            )
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  void _showFancyPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Label",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 600.h,
                  width: 300.w,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(40.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.r,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "To Access, Please Enter The Numbers",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Code Input
                      Text(
                        "Zero, Nine, Six, Seven",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Input Field
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          hintText: "Enter code",
                        ),
                        keyboardType: TextInputType.none,
                        showCursor: true,
                        readOnly: true,
                      ),

                      // Numeric Keyboard
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        children: [
                          // Numbers 1-9
                          for (int i = 1; i <= 9; i++)
                            _buildKeyButton(i.toString(), onTap: () {
                              setState(() {
                                _codeController.text += i.toString();
                              });
                            }),

                          // Delete button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_codeController.text.isNotEmpty) {
                                  _codeController.text = _codeController.text
                                      .substring(
                                          0, _codeController.text.length - 1);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.backspace,
                                size: 24.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),

                          // Number 0
                          _buildKeyButton("0", onTap: () {
                            setState(() {
                              _codeController.text += "0";
                            });
                          }),

                          // Submit button
                          GestureDetector(
                            onTap: () {
                              // Handle submit action
                              sl<NavigationService>().goBack();
                              sl<NavigationService>().pushNamed(
                                RoutesNames.settings,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.send,
                                size: 24.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80.h,
              left: 80.w,
              right: 80.w,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF00F1F8),
                      Color(0xFF0076BE),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                width: 70.w,
                height: 50.h,
                child: Center(
                  child: Text(
                    "FOR GROWN-UPS",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),

            // Close Button
            Positioned(
              top: 80.h,
              right: 10.w,
              child: IconButton(
                icon: Container(
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
  }

  Widget _buildKeyButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
