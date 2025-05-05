import 'package:autis/src/patient/domain/entities/question_entity.dart';

class LevelEntity {
  final int id;
  final String gameId;
  final int stars;
  final int userScore;
  final int maxScore;
  final List<QuestionEntity> questions;

  LevelEntity({
    required this.id,
    required this.gameId,
    required this.userScore,
    required this.maxScore,
    required this.stars,
    required this.questions,
  });

  factory LevelEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> questionsFromJson = json['questions'];
    List<QuestionEntity> questionsList = questionsFromJson
        .map((q) => QuestionEntity.fromJson(q as Map<String, dynamic>))
        .toList();
    return LevelEntity(
      id: json['id'] as int,
      gameId: json['gameId'] as String,
      userScore: json['userScore'] as int,
      maxScore: json['maxScore'] as int,
      stars: json['stars'] as int,
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'userScore': userScore,
      'maxScore': maxScore,
      'stars': stars,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
