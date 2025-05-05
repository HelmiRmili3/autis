import 'package:autis/src/patient/domain/entities/level_entity.dart';

import '../../domain/entities/question_entity.dart';

class LevelModel extends LevelEntity {
  LevelModel({
    required super.questions,
    required super.id,
    required super.gameId,
    required super.userScore,
    required super.maxScore,
    required super.stars,
  });
  factory LevelModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> questionsFromJson = json['questions'];
    List<QuestionEntity> questionsList = questionsFromJson
        .map((q) => QuestionEntity.fromJson(q as Map<String, dynamic>))
        .toList();
    return LevelModel(
      questions: questionsList,
      id: json['id'] as int,
      gameId: json['gameId'] as String,
      userScore: json['userScore'] as int,
      maxScore: json['maxScore'] as int,
      stars: json['stars'] as int,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questions': questions.map((q) => q.toJson()).toList(),
      'gameId': gameId,
      'userScore': userScore,
      'maxScore': maxScore,
      'stars': stars,
    };
  }
}
