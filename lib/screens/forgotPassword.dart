import 'dart:convert';

import '../webservices/AuthServices.dart';
import '../widgets/compound/registrationInputField.dart';
import '../widgets/simple/button.dart';

import '../utilities/utilities.dart';
import 'package:flutter/material.dart';

import '../models/constants.dart';

import '../widgets/compound/dialogs.dart';
import 'homepage.dart';
import 'verification.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgot-password';
  @override
  State<StatefulWidget> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPassword> {
  TextEditingController emailController = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future<void> _navigateToVerification(BuildContext ctx) async {
    final email = emailController.text;
    if (email.isEmpty) {
      ShowValidationMessage.showMessage(ctx, 'Email field is empty');
      return;
    }
    print('email : $email');
    if (email.contains(new RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$'))) {
      Dialogs.showLoadingDialog(ctx, _keyLoader);

      //Send token to the email
      //int token = await APICalls().sendEmail(emailController.text);
      var res = await AuthService.generateOtp(email);
      if (res.statusCode == 200 && !res.body.contains('error')) {
        debugPrint('${res.body}');
        //Remove the loading icon after email has been sent
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        //Navigate to Token Verification screen
        Navigator.of(ctx).pushReplacementNamed(
          Verification.routeName,
          arguments: {
            'email': email,
            'page': 'ForgotPassword',
          },
        );
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        if (res.statusCode == 200) {
          Map<String, dynamic> content = jsonDecode(res.body);
          ShowValidationMessage.showMessage(ctx, content['error']);
        } else {
          debugPrint('Error : ${res.statusCode} : ${res.body}');
        }
      }
    } else {
      print('invalid email id..');
      ShowValidationMessage.showMessage(ctx, 'Invalid email id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      //showDialog<bool>(
      //    context: context, builder: (c) => ExitWarningAlert(c)),
      child: Scaffold(
        body: Builder(
          builder: (context) => SafeArea(
            child: GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(new FocusNode()),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: double.infinity,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1,
                                right: MediaQuery.of(context).size.width * 0.1),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(
                                  AppConstants.imagesFolder + 'Forgot_Icon.png'),
                            ),
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                'Enter the email adress associated with your account',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                'We will email you a link to reset your password',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.grey[400],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          //Email Text Field
                          // Container(
                          //   alignment: Alignment.centerRight,
                          //   margin: EdgeInsets.only(top: 20, bottom: 20),
                          //   child: CustomTextField(
                          //     hintText: 'Email',
                          //     width: MediaQuery.of(context).size.width * 0.8,
                          //     controller: emailController,
                          //   ),
                          // ),

                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: RegistrationInputField(
                              'Email',
                              controller: emailController,
                            ),
                          ),
                          SizedBox(height: 20),

                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Button(
                              'SEND',
                              onPressed: () {
                                _navigateToVerification(context);
                              },
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                          ),
                        ],
                      ),
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