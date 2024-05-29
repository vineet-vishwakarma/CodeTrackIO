import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

h1Style() {
  return const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
    color: Colors.lightBlueAccent,
  );
}

h2Style() {
  return const TextStyle(
    fontSize: 25,
    color: Colors.white,
  );
}

h3Style() {
  return const TextStyle(
    fontSize: 15,
    color: Colors.white,
  );
}
