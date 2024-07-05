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
    final String iconUrl = icon;
    List<String> parts = iconUrl.split('/');
    String extracted = parts.last;
    return Column(
      children: [
        Image.network(
            icon.contains('https://leetcode.com/static/images/badges/2024/gif/')
                ? 'https://assets.leetcode.com/static_assets/public/images/badges/2024/gif/$extracted'
                : icon,
            width: 90),
        Text(name),
        Text(date),
      ],
    );
  }
}
