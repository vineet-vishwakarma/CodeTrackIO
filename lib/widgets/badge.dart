import 'package:flutter/material.dart';

class Badges extends StatelessWidget {
  final String icon;
  final String name;
  final String date;
  const Badges({
    super.key,
    required this.icon,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(icon, width: 90),
        Text(name),
        Text(date),
      ],
    );
  }
}
