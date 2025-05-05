import 'package:autis/core/utils/enums/role_enum.dart';
import 'package:autis/src/common/blocs/game_bloc/game_bloc.dart';
import 'package:autis/src/common/blocs/game_bloc/game_event.dart';
import 'package:autis/src/common/view/container_screen.dart';
import 'package:autis/src/patient/domain/entities/level_entity.dart';
import 'package:autis/src/patient/domain/entities/question_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';

class LevelQuestionsScreen extends StatefulWidget {
  final LevelEntity level;
  const LevelQuestionsScreen({
    super.key,
    required this.level,
  });

  @override
  State<LevelQuestionsScreen> createState() => _LevelQuestionsScreenState();
}

class _LevelQuestionsScreenState extends State<LevelQuestionsScreen> {
  int _currentQuestionIndex = 0;
  late List<QuestionEntity> _questions;
  late List<int?> _userAnswers;

  @override
  void initState() {
    super.initState();
    _questions = widget.level.questions;
    _userAnswers = List.filled(_questions.length, null);
  }

  void _selectAnswer(int userAnswer) {
    final questionIndex = _currentQuestionIndex;

    setState(() {
      _userAnswers[questionIndex] = userAnswer;
    });

    // Update game in Firestore
    sl<GameBloc>().add(
      UpdateGame(
        widget.level.gameId.toString(),
        "8xsGMVeNAXX72eamUoNq6cEO0Ky1",
        widget.level.id.toString(),
        questionIndex,
        userAnswer,
      ),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() => _currentQuestionIndex++);
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].answerIndex) {
        score += _questions[i].questionScore;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text("You scored $score points!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _userAnswers = List.filled(_questions.length, null);
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () => sl<NavigationService>().goToNamed(
              RoutesNames.home,
              extra: Role.patient,
            ),
            child: const Text('Go Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isAnswered = _userAnswers[_currentQuestionIndex] != null;

    return ContainerScreen(
      title: '${Strings.level} ${widget.level.id}',
      imagePath: 'assets/images/homebg.png',
      leadingicon: Icons.arrow_back_ios_new_rounded,
      onLeadingPress: () => sl<NavigationService>().goBack(),
      children: [
        const SizedBox(height: 20),
        Text(
          "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Image.network(
          currentQuestion.imageUrl,
          height: 200.h,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        ...List.generate(currentQuestion.options.length, (index) {
          final optionText = currentQuestion.options[index];
          final isSelected = _userAnswers[_currentQuestionIndex] == index;
          final isCorrect = currentQuestion.answerIndex == index;

          return GestureDetector(
            onTap: isAnswered ? null : () => _selectAnswer(index),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isAnswered
                    ? isCorrect
                        ? Colors.green
                        : isSelected
                            ? Colors.red
                            : Colors.white
                    : isSelected
                        ? Colors.blueAccent
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                optionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected || (isAnswered && isCorrect)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}
