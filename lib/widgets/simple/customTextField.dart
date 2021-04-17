import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final double width;
  final String obscuringChar;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextStyle hintStyle;
  final Widget suffixIcon;
  final String errorText;
  final bool disabled;
  final Function(String) onChanged;
  final InputBorder border;
  final double fontSize;
  CustomTextField({
    this.hintText,
    this.labelText,
    this.controller,
    this.width,
    this.fontSize = 15,
    this.obscureText = false,
    this.obscuringChar = '*',
    this.keyboardType = TextInputType.text,
    this.hintStyle = const TextStyle(fontSize: 16),
    this.suffixIcon,
    this.errorText,
    this.onChanged,
    this.disabled = false,
    this.border,
  });

  //bool _error = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 3,
          child: Container(
            width: width,
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              obscureText: obscureText,
              obscuringCharacter: obscuringChar,
              style: TextStyle(
                fontSize: fontSize,
              ),
              keyboardType: keyboardType,
              readOnly: disabled,
              textAlign: TextAlign.start,

              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                hintStyle: hintStyle,
                contentPadding: EdgeInsets.all(10),
                border: border!=null?border:InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ),
        errorText != null && errorText.length > 0
            ? Container(
                margin: EdgeInsets.only(bottom: 10),
                width: width,
                //alignment: Alignment.centerRight,
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(bottom: 10),
              ),
      ],
    );
  }
}
