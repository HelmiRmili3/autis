import 'package:autis/src/patient/domain/entities/level_entity.dart';

class GameEntity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String genre;
  final bool open;
  final int userScore;
  final int maxScore;
  final int type;
  final int levelsCount;
  final List<LevelEntity> levels;

  GameEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.open,
    required this.type,
    required this.genre,
    required this.userScore,
    required this.maxScore,
    required this.levelsCount,
    required this.levels,
  });

  factory GameEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> levelsFromJson = json['levels'];
    List<LevelEntity> levelsList = levelsFromJson
        .map((l) => LevelEntity.fromJson(l as Map<String, dynamic>))
        .toList();

    return GameEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      open: json['open'] as bool,
      type: json['type'] as int,
      userScore: json['userScore'] as int,
      maxScore: json['maxScore'] as int,
      genre: json['genre'] as String,
      levelsCount:
          json['levelsCount'] as int, // Changed from 'levels' to 'levelsCount'
      levels: levelsList, // Now properly parsing the levels list
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'open': open,
      'genre': genre,
      'type': type,
      'userScore': userScore,
      'maxScore': maxScore,
      'levelsCount': levelsCount,
      'levels': levels.map((level) => level.toJson()).toList(),
    };
  }
}
