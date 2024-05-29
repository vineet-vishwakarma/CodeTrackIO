import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

toast(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    webBgColor: "linear-gradient(#24222a,#24222a)",
    timeInSecForIosWeb: 3,
    backgroundColor: const Color.fromRGBO(36, 34, 42, 255),
  );
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
