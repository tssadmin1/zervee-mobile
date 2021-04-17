import 'dart:convert';

import '../webservices/AuthServices.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../models/constants.dart';
import '../widgets/compound/registrationInputField.dart';
import '../widgets/simple/button.dart';
import 'package:flutter/gestures.dart';

import '../utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../widgets/compound/dialogs.dart';
import '../widgets/compound/LogoWithText_Header.dart';
import '../widgets/compound/SocialMediaSignIn.dart';

import 'SignIn.dart';
import 'homepage.dart';
import 'verification.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/sign-up';
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _signUpForm = new GlobalKey<FormState>();
  bool showPwd = true;
  bool _acceptedTerms = false;
  String _mobileNumberError = "";
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _mobNumberController = TextEditingController();
  TextEditingController _mobNumberErr = TextEditingController();

  @override
  dispose() {
    print('Dispose method from signup page');
    _usernameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _mobNumberController.dispose();
    super.dispose();
  }

  String _passwordValidation(String value) {
    if (value.length < 8) return 'At least 8 characters';
    bool flag = value.contains(RegExp(AppConstants.pwdPolicies[1])) &&
        value.contains(RegExp(AppConstants.pwdPolicies[2])) &&
        value.contains(RegExp(AppConstants.pwdPolicies[3]));
    if (flag) return null;
    return 'Requires at least 1 uppercase char, 1 lowercase char, 1 digit';
  }

  Future<void> _signUp(BuildContext context) async {
    final email = _emailController.text.trim();
    final name = _usernameController.text.trim();
    final pwd = _pwdController.text.trim();
    final mobileNo = _mobNumberController.text.trim();
    String msg = '';
    bool flag = true;
    if (!_acceptedTerms) {
      msg = 'Please accept the terms and conditions';
      ShowValidationMessage.showMessage(context, msg);
      flag = false;
    }
    if (flag) {
      Dialogs.showLoadingDialog(context, _keyLoader);
      var res = await AuthService.signUp(
        name: name,
        email: email,
        mobileNumber: mobileNo,
        password: pwd,
        signUpType: 'zervee',
      );

      if (res.statusCode == 200 && !res.body.contains('error')) {
        debugPrint('SignedUp successfully, sending verification token');
        var otpResponse = await AuthService.generateOtp(email);
        if (otpResponse.statusCode == 200 &&
            !otpResponse.body.contains('error')) {
          debugPrint('Verification OTP sent successfully');
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          debugPrint('Navigating to Verification screen');
          Navigator.of(context)
              .pushReplacementNamed(Verification.routeName, arguments: {
            'email': email,
            'page': 'SignUp',
          });
        } else if (otpResponse.statusCode == 200 &&
            otpResponse.body.contains('error')) {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          Map<String, dynamic> errorRes = jsonDecode(otpResponse.body);
          ShowValidationMessage.showMessage(context, errorRes['error']);
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          debugPrint('Generate OTP failed...');
          debugPrint('${otpResponse.statusCode} : ${otpResponse.body}');
        }
      } else if (res.statusCode == 200 && res.body.contains('error')) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Map<String, dynamic> errorRes = jsonDecode(res.body);
        ShowValidationMessage.showMessage(context, errorRes['error']);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        ShowValidationMessage.showMessage(
            context, 'Something went wrong during signup');
      }
    }
  }

  void _submitForm(BuildContext context) {
    if (!_signUpForm.currentState.validate() ||
        (_mobNumberErr.text != null && _mobNumberErr.text.isNotEmpty)) {
      ShowValidationMessage.showMessage(context, 'Please check validations');
      return;
    }
    _signUp(context);
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
        return true;
      },
      child: Scaffold(
        body: Builder(
          builder: (context) => SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          //width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        FittedBox(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: LogoWithTextHeader(''),
                          ),
                        ),

                        //Sign Up form
                        Form(
                          key: _signUpForm,
                          child: SingleChildScrollView(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RegistrationInputField(
                                    'Full Name',
                                    isMandatory: true,
                                    controller: _usernameController,
                                    validator: (value) {
                                      if (value.length < 4)
                                        return 'Name cannot be less than 4 characters';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  RegistrationInputField(
                                    'Email id',
                                    isMandatory: true,
                                    controller: _emailController,
                                    validator: (value) {
                                      if (!value.contains(new RegExp(
                                          '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9]+\$')))
                                        return 'Invalid email';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),

                                  //Custom Mobile number field
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                          text: 'Mobile',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ])),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[300]),
                                        ),
                                        child: InternationalPhoneNumberInput(
                                          onInputChanged: (PhoneNumber number) {
                                            //print(number.phoneNumber);
                                            //this.number = number;
                                          },
                                          onInputValidated: (bool value) {
                                            print(value);
                                            if (value) {
                                              _mobNumberController.text =
                                                  this.number.phoneNumber;
                                              setState(() {
                                                _mobileNumberError = '';
                                                _mobNumberErr.text = '';
                                              });
                                            } else
                                              setState(() {
                                                _mobileNumberError =
                                                    'invalid mobile number';
                                                _mobNumberErr.text =
                                                    _mobileNumberError;
                                              });
                                          },
                                          selectorConfig: SelectorConfig(
                                            selectorType:
                                                PhoneInputSelectorType.DIALOG,
                                            setSelectorButtonAsPrefixIcon: true,
                                          ),
                                          ignoreBlank: false,
                                          autoValidateMode:
                                              AutovalidateMode.disabled,
                                          selectorTextStyle:
                                              TextStyle(color: Colors.black),
                                          textFieldController:
                                              _mobNumberController,
                                          formatInput: false,
                                          keyboardType: TextInputType.number,
                                          inputBorder: InputBorder.none,
                                        ),
                                      ),
                                      _mobileNumberError != null &&
                                              _mobileNumberError.length > 0
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
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
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                            ),
                                    ],
                                  ),
                                  //End Custom Mobile Number field

                                  SizedBox(height: 10),
                                  //Password
                                  RegistrationInputField(
                                    'Password',
                                    isMandatory: true,
                                    controller: _pwdController,
                                    validator: (value) {
                                      return _passwordValidation(value);
                                    },
                                    obscureText: showPwd,
                                    suffixIcon: IconButton(
                                      icon: showPwd
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(
                                          () {
                                            print('show/hide pwd');
                                            showPwd = !showPwd;
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  //Terms and conditions field
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          visualDensity:
                                              VisualDensity.comfortable,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: _acceptedTerms,
                                          onChanged: (flag) {
                                            setState(() {
                                              _acceptedTerms = flag;
                                            });
                                          },
                                        ),
                                        RichText(
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
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Utilities.launchURL(
                                                            AppConstants
                                                                .privacyPolicyUrl);
                                                      },
                                                style: TextStyle(
                                                  color: AppConstants
                                                      .themeColorShade1,
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
                                                  color: AppConstants
                                                      .themeColorShade1,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Utilities.launchURL(
                                                            AppConstants
                                                                .termsOfServiceUrl);
                                                      },
                                              ),
                                              //TextSpan()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  Button(
                                    'Sign-up',
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    onPressed: () => _submitForm(context),
                                  ),
                                  SizedBox(height: 10),
                                  //Social Media options
                                  FittedBox(
                                    child: Container(
                                      child: SocialMedialSignIn(_keyLoader),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  //Sign-up option
                                  Container(
                                    alignment: Alignment.center,
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Have an account ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
                                      TextSpan(
                                          text: 'Sign-in',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context)
                                                  .pushNamed(SignIn.routeName);
                                            },
                                          style: TextStyle(
                                            color: Colors.accents.first,
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                    ])),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.routeName, (r) => false);
                        }),
                    top: 1,
                    left: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
