import 'package:autis/src/doctor/persentation/widgets/costom_appbar.dart';
import 'package:autis/src/patient/domain/entities/game_entity.dart';
import 'package:flutter/material.dart';

class DoctorGameDetails extends StatefulWidget {
  final GameEntity game;
  const DoctorGameDetails({
    super.key,
    required this.game,
  });

  @override
  State<DoctorGameDetails> createState() => _DoctorGameDetailsState();
}

class _DoctorGameDetailsState extends State<DoctorGameDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.game.name,
        active: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columnSpacing: 20,
              horizontalMargin: 10,
              dataRowMinHeight: 100,
              dataRowMaxHeight: 200,
              columns: [
                const DataColumn(
                  label: Text('المستوى'),
                  tooltip: 'رقم المستوى',
                ),
                ...List.generate(
                  widget.game.levels.first.questions.length,
                  (index) => DataColumn(
                    label: Text('السؤال ${index + 1}'),
                    tooltip: 'تفاصيل السؤال ${index + 1}',
                  ),
                ),
                const DataColumn(
                  label: Text('النتيجة'),
                  tooltip: 'نتيجة المستوى',
                ),
              ],
              rows: widget.game.levels.map((level) {
                return DataRow(
                  cells: [
                    DataCell(
                      Center(child: Text('المستوى ${level.id}')),
                    ),
                    ...level.questions.map((question) {
                      final hasUserAnswer = question.userAnswerIndex != -1;
                      final isCorrect = hasUserAnswer &&
                          question.userAnswerIndex == question.answerIndex;

                      return DataCell(
                        SingleChildScrollView(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // User's answer (if available)
                                if (hasUserAnswer)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'إجابتك:',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                      _buildAnswerOption(
                                        question
                                            .options[question.userAnswerIndex],
                                        isUserAnswer: true,
                                        isCorrect: isCorrect,
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),

                                // Correct answer
                                const Text(
                                  'الإجابة الصحيحة:',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                                _buildAnswerOption(
                                  question.options[question.answerIndex],
                                  isCorrectAnswer: true,
                                ),

                                const SizedBox(height: 8),

                                // All options
                                ...question.options
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final isUserAnswer = hasUserAnswer &&
                                      entry.key == question.userAnswerIndex;
                                  final isRightAnswer =
                                      entry.key == question.answerIndex;

                                  // Skip if this is already shown as user/correct answer
                                  if (isUserAnswer || isRightAnswer) {
                                    return const SizedBox();
                                  }

                                  return _buildAnswerOption(entry.value);
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    DataCell(
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${level.userScore}/${level.maxScore}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(level.userScore / level.maxScore * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: _getScoreColor(
                                    level.userScore, level.maxScore),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOption(
    String option, {
    bool isUserAnswer = false,
    bool isCorrectAnswer = false,
    bool isCorrect = false,
  }) {
    Color backgroundColor = Colors.grey.withOpacity(0.1);
    Color textColor = Colors.black;
    IconData? icon;

    if (isCorrectAnswer) {
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      icon = Icons.check;
    } else if (isUserAnswer) {
      backgroundColor = isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1);
      textColor = isCorrect ? Colors.green : Colors.red;
      icon = isCorrect ? Icons.check : Icons.close;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 4),
          Text(
            option,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score, int maxScore) {
    final percentage = score / maxScore;
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
