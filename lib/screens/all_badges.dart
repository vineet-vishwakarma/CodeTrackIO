import 'package:codetrackio/widgets/badge.dart';
import 'package:flutter/material.dart';

class AllBadges extends StatelessWidget {
  final List<dynamic> badges;
  const AllBadges({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height * 0.36,
      child: Center(
        child: GridView.builder(
          itemCount: badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Badges(
              icon: badges[index]['medal']['config']['iconGif'],
              name: badges[index]['shortName'],
              date: badges[index]['creationDate'],
            );
          },
        ),
      ),
    );
  }
}
