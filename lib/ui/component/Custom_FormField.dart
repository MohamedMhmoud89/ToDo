import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/Setting_Provider.dart';

typedef MyValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  bool isPassword;
  MyValidator validator;
  TextEditingController controller;
  int lines;

  CustomFormField(
      {required this.controller,
      required this.label,
      this.isPassword = false,
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.lines = 1});

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return TextFormField(
      maxLines: lines,
      minLines: lines,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(
          color: settingProvider.currentTheme == ThemeMode.light
              ? Colors.black
              : Colors.white),
      decoration: InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(
            borderSide: BorderSide(
                color: settingProvider.currentTheme == ThemeMode.light
                    ? Colors.black
                    : Colors.white)),
        labelStyle: TextStyle(
            color: settingProvider.currentTheme == ThemeMode.light
                ? Colors.black
                : Colors.white),
      ),
      validator: validator,
      controller: controller,
    );
  }
}
