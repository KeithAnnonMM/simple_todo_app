import 'package:flutter/material.dart';

TextFormField reusableTextField(String text, TextEditingController controller,
    bool isPasswordType, Icon prefixIcon, validate) {
  return TextFormField(
    controller: controller,
    validator: validate,
    obscureText: isPasswordType,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    decoration: InputDecoration(
      label: Text(text),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      prefixIcon: prefixIcon,
    ),
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.text,
  );
}

TextField reusableTodoField(
    String text, TextEditingController controller, bool isPasswordType) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    decoration: InputDecoration(
      label: Text(text),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.grey.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.text,
  );
}
