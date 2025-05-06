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
          leadingicon: Icons.video_call,
          onLeadingPress: () {
            sl<NavigationService>().pushNamed(
              RoutesNames.patientvediosscreen,
            );
          },
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
}
