import 'package:codetrackio/widgets/badge.dart';
import 'package:codetrackio/widgets/language_chip.dart';
import 'package:flutter/material.dart';

class AllBadges extends StatelessWidget {
  final List<dynamic> badges;
  const AllBadges({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      width: width * 0.9,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        spacing: 20,
        runSpacing: 10,
        children: badges.isEmpty
            ? [const LanguageChip(text: 'Not Available')]
            : badges.map((badge) {
                return Tooltip(
                  message: badge['hoverText'],
                  child: Badges(
                    icon: badge['medal']['config']['iconGif'],
                    name: badge['shortName'],
                    date: badge['creationDate'],
                  ),
                );
              }).toList(),
      ),
    );
  }
}
