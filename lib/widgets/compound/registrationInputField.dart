import 'package:flutter/material.dart';

class RegistrationInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget suffixIcon;
  final String obscuringCharacter;
  final bool obscureText;
  final String Function(String) validator;
  final Function(String) onSaved;
  final TextEditingController controller;
  final bool isMandatory;
  final TextInputType keyboardType;
  RegistrationInputField(
    this.label, {
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.validator,
    this.onSaved,
    this.controller,
    this.isMandatory = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: label,
            style: TextStyle(color: Colors.grey),
          ),
          isMandatory?TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red),
          ):TextSpan(),
        ])),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          onSaved: onSaved,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.only(left: 5),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
            errorStyle: TextStyle(color: Colors.red),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
