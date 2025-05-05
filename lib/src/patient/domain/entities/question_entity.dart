class QuestionEntity {
  final String question;
  final String imageUrl;
  final List<String> options;
  final int answerIndex;
  final int userAnswerIndex;
  final int questionScore;

  QuestionEntity({
    required this.question,
    required this.imageUrl,
    required this.options,
    required this.answerIndex,
    required this.userAnswerIndex,
    required this.questionScore,
  });

  factory QuestionEntity.fromJson(Map<String, dynamic> json) {
    return QuestionEntity(
      question: json['question'] as String,
      imageUrl: json['imageUrl'] as String,
      options: List<String>.from(json['options'] as List),
      answerIndex: json['answerIndex'] as int,
      userAnswerIndex: json['userAnswerIndex'] as int,
      questionScore: json['questionScore'] as int, // Added questionScore
    );
  }

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
