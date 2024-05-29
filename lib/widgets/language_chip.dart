import 'package:flutter/material.dart';

class LanguageChip extends StatelessWidget {
  final String text;
  const LanguageChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      color:
          MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
      side: BorderSide.none,
    );
  }
}
