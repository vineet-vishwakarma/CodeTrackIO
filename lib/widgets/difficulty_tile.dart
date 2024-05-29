import 'package:flutter/material.dart';

class DifficultyTile extends StatelessWidget {
  final double size;
  final String difficulty;
  final int totalQuestion;
  final int solvedQuestion;
  final Color color;
  const DifficultyTile(
      {super.key,
      required this.size,
      required this.difficulty,
      required this.totalQuestion,
      required this.solvedQuestion,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: size / 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              difficulty,
              style: TextStyle(color: color),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  solvedQuestion.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size < 768 ? 14 : 18,
                  ),
                ),
                Text(
                  ' /$totalQuestion',
                  style: TextStyle(
                    fontSize: size < 768 ? 14 : 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      subtitle: LinearProgressIndicator(
        borderRadius: BorderRadius.circular(8),
        minHeight: 6,
        backgroundColor: Colors.grey,
        value: (solvedQuestion == 0 || totalQuestion == 0)
            ? 0
            : solvedQuestion / totalQuestion,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
