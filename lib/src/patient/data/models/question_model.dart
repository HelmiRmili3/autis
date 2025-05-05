import 'package:autis/src/patient/domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.question,
    required super.imageUrl,
    required super.options,
    required super.answerIndex,
    required super.userAnswerIndex,
    required super.questionScore, // Added questionScore
  });
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] as String,
      imageUrl: json['imageUrl'] as String,
      options: List<String>.from(json['options'] as List),
      answerIndex: json['answerIndex'] as int,
      userAnswerIndex: json['userAnswerIndex'] as int,
      questionScore: json['questionScore'] as int, // Added questionScore
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'imageUrl': imageUrl,
      'options': options,
      'answerIndex': answerIndex,
      'userAnswerIndex': userAnswerIndex,
      'questionScore': questionScore, // Added questionScore
    };
  }
}
