import 'package:autis/core/routes/route_names.dart';
import 'package:autis/src/common/view/container_screen.dart';
import 'package:autis/src/patient/domain/entities/game_entity.dart';
import 'package:autis/src/patient/persentation/widgets/level_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';

class GameLevelScreen extends StatefulWidget {
  final GameEntity game;
  const GameLevelScreen({
    super.key,
    required this.game,
  });

  @override
  State<GameLevelScreen> createState() => _GameLevelScreenState();
}

class _GameLevelScreenState extends State<GameLevelScreen> {
  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: Strings.levels,
      imagePath: 'assets/images/homebg.png',
      leadingicon: Icons.arrow_back_sharp,
      onLeadingPress: () => sl<NavigationService>().goBack(),
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            padding: const EdgeInsets.all(2.0),
            children: widget.game.levels
                .map(
                  (level) => LevelCard(
                    level: level.id,
                    image: 'assets/images/n${level.stars}.png',
                    onPressed: () => sl<NavigationService>().pushNamed(
                      RoutesNames.questions,
                      extra: level,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
