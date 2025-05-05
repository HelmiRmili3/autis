import '../../domain/entities/game_entity.dart';
import '../../domain/entities/level_entity.dart';

class GameModel extends GameEntity {
  GameModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.open,
    required super.type,
    required super.userScore,
    required super.maxScore,
    required super.genre,
    required super.levelsCount,
    required super.levels,
  });
  factory GameModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> levelsFromJson = json['levels'];
    List<LevelEntity> levelsList = levelsFromJson
        .map((l) => LevelEntity.fromJson(l as Map<String, dynamic>))
        .toList();

    return GameModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      open: json['open'] as bool,
      type: json['type'] as int,
      userScore: json['userScore'] as int,
      maxScore: json['maxScore'] as int,
      genre: json['genre'] as String,
      levelsCount: json['levelsCount'] as int,
      levels: levelsList,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'genre': genre,
      'open': open,
      'type': type,
      'userScore': userScore,
      'maxScore': maxScore,
      'levelsCount': levelsCount,
      'levels': levels.map((level) => level).toList(),
    };
  }

  Map<String, dynamic> initGame() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'open': open,
      'genre': genre,
      'type': type,
      'userScore': 0,
      'maxScore': maxScore,
      'levelsCount': levelsCount,
      'levels': levels.map((level) => level.toJson()).toList(),
    };
  }
}
