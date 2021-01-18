import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    @required this.onChange,
    @required this.textStyle,
    @required this.labelText,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final TextStyle textStyle;
  final String labelText;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle,
      onChanged: onChange,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: textStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
    );
  }
}
