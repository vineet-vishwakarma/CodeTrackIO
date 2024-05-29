import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData icon;
  final double width;
  final double vertical;
  final double horizontal;
  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    required this.icon,
    required this.width, required this.vertical, required this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              // color: ThemeData.dark().hoverColor,
              color: Colors.white24,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.grey.shade600,
              )),
        ),
      ),
    );
  }
}
