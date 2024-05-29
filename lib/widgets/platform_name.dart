import 'package:codetrackio/utils/utils.dart';
import 'package:flutter/material.dart';

class PlatformName extends StatelessWidget {
  final String name;
  final String imgUrl;
  const PlatformName({super.key, required this.name, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80,
          child: Image.network(
            imgUrl,
            width: 80,
          ),
        ),
        Text(
          name,
          style: h2Style(),
        ),
      ],
    );
  }
}

class PlatformLoader extends StatelessWidget {
  const PlatformLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 325,
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()));
  }
}
