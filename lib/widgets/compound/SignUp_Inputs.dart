import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../models/constants.dart';
import '../../utilities/utilities.dart';
import 'package:flutter/gestures.dart';

import '../simple/customTextField.dart';
import 'package:flutter/material.dart';

class SignUpInputFields extends StatefulWidget {
  final TextEditingController userName;
  final TextEditingController email;
  final TextEditingController pwd;
  final TextEditingController mobNumber;
  final TextEditingController acceptedTerms;
  final TextEditingController mobNumberError;
  SignUpInputFields({
    this.userName,
    this.email,
    this.pwd,
    this.mobNumber,
    this.mobNumberError,
    this.acceptedTerms,
  });

  @override
  _SignUpInputFieldsState createState() => _SignUpInputFieldsState();
}

class _SignUpInputFieldsState extends State<SignUpInputFields> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  bool showPwd = false;
  bool _acceptedTerms = false;
  String _usernameError = '';
  String _emailError = '';
  String _passwordError = "";
  String _mobileNumberError = "";
  double fontSize = 16;

  void _usernameValidation(String value) {
    if (value != null && value.length < 4 && value.length > 0) {
      setState(() {
        _usernameError = "username can not have less than 4 characters";
      });
    } else {
      setState(() {
        _usernameError = "";
      });
    }
  }

  void _emailValidation(String value) {
    if (value != null &&
        value.length > 0 &&
        !value.contains(
            new RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9]+\$'))) {
      setState(() {
        _emailError = "Invalid email id";
      });
    } else {
      setState(() {
        _emailError = "";
      });
    }
  }

  void _passwordValidation(String value) {
    if(value.contains(RegExp('''[!@#\$%^&*()\'\+\=\`~\|]''')))
      print('matches');
    else
      print('No matches');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //username field
              CustomTextField(
                hintText: 'Username',
                fontSize: fontSize,
                width: MediaQuery.of(context).size.width * 0.8,
                controller: widget.userName,
                errorText: _usernameError,
                onChanged: (value) => _usernameValidation(value),
              ),
              //email field
              CustomTextField(
                hintText: 'Email',
                fontSize: fontSize,
                width: MediaQuery.of(context).size.width * 0.8,
                controller: widget.email,
                errorText: _emailError,
                onChanged: (value) => _emailValidation(value),
                keyboardType: TextInputType.emailAddress,
              ),
              //telephone field
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      //height: 50,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          //print(number.phoneNumber);
                          //this.number = number;
                        },
                        onInputValidated: (bool value) {
                          print(value);
                          if (value) {
                            widget.mobNumber.text = this.number.phoneNumber;
                            setState(() {
                              _mobileNumberError = '';
                              widget.mobNumberError.text = _mobileNumberError;
                            });
                          } else
                            setState(() {
                              _mobileNumberError = 'invalid mobile number';
                              widget.mobNumberError.text = _mobileNumberError;
                            });
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          setSelectorButtonAsPrefixIcon: true,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        textFieldController: widget.mobNumber,
                        formatInput: false,
                        keyboardType: TextInputType.number,
                        inputBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  _mobileNumberError != null && _mobileNumberError.length > 0
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10),
                          //alignment: Alignment.centerRight,
                          child: Text(
                            _mobileNumberError,
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
              ),
              //password field
              CustomTextField(
                hintText: 'Password',
                fontSize: fontSize,
                width: MediaQuery.of(context).size.width * 0.8,
                obscureText: !showPwd,
                obscuringChar: '*',
                controller: widget.pwd,
                errorText: _passwordError,
                onChanged: (value) => _passwordValidation(value),
                suffixIcon: IconButton(
                  icon: showPwd
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      print('show/hide pwd');
                      showPwd = !showPwd;
                      widget.acceptedTerms.text = showPwd.toString();
                    });
                  },
                ),
              ),
              //Terms and conditions field
              Row(
                children: [
                  Checkbox(
                      value: _acceptedTerms,
                      onChanged: (flag) {
                        setState(() {
                          _acceptedTerms = flag;
                          widget.acceptedTerms.text = flag.toString();
                        });
                      }),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "I accept Zervee's ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Data Policy ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Utilities.launchURL('https://www.zervee.com');
                              },
                            style: TextStyle(
                              color: AppConstants.themeColorShade1,
                            ),
                          ),
                          TextSpan(
                            text: "and ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Terms and Conditions.",
                            style: TextStyle(
                              color: AppConstants.themeColorShade1,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Utilities.launchURL('https://www.zervee.com');
                              },
                          ),
                          //TextSpan()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
