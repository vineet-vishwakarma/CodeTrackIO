import 'package:codetrackio/utils/utils.dart';
import 'package:codetrackio/widgets/difficulty_tile.dart';
import 'package:flutter/material.dart';

class PlatformCard extends StatelessWidget {
  final double size;
  final int totalQuestions;
  final int easyQuestionSolved;
  final int mediumQuestionSolved;
  final int hardQuestionSolved;
  final int easyQuestions;
  final int mediumQuestions;
  final int hardQuestions;
  const PlatformCard(
      {super.key,
      required this.size,
      required this.totalQuestions,
      required this.easyQuestionSolved,
      required this.mediumQuestionSolved,
      required this.hardQuestionSolved,
      required this.easyQuestions,
      required this.mediumQuestions,
      required this.hardQuestions});

  @override
  Widget build(BuildContext context) {
    double easyProgress = easyQuestionSolved / totalQuestions;
    double mediumProgress =
        easyProgress + (mediumQuestionSolved / totalQuestions);
    double hardProgress =
        easyProgress + mediumProgress + (hardQuestionSolved / totalQuestions);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.grey,
                value: hardProgress,
                strokeCap: StrokeCap.round,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                value: mediumProgress,
                strokeCap: StrokeCap.round,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                value: easyProgress,
                strokeCap: StrokeCap.round,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
              ),
            ),
            Column(
              children: [
                Text(
                  '${easyQuestionSolved + mediumQuestionSolved + hardQuestionSolved}',
                  style: h2Style(),
                ),
                const Text(
                  'Solved',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        DifficultyTile(
          size: size,
          difficulty: 'Easy',
          totalQuestion: easyQuestions,
          solvedQuestion: easyQuestionSolved,
          color: Colors.tealAccent,
        ),
        DifficultyTile(
          size: size,
          difficulty: 'Medium',
          totalQuestion: mediumQuestions,
          solvedQuestion: mediumQuestionSolved,
          color: Colors.amberAccent,
        ),
        DifficultyTile(
          size: size,
          difficulty: 'Hard',
          totalQuestion: hardQuestions,
          solvedQuestion: hardQuestionSolved,
          color: Colors.red,
        ),
      ],
    );
  }
}
