import 'package:flutter/material.dart';
import 'package:sunny_connect/utils/colors.dart';

class Utilities {
  static textField(String lable, bool obscure, TextInputAction textInputAction,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: lable,
        labelStyle: const TextStyle(fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
