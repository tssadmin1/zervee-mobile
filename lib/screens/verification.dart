import 'dart:convert';

import '../screens/SignIn.dart';
import '../screens/resetPassword.dart';
import '../webservices/AuthServices.dart';
import '../widgets/compound/registrationInputField.dart';

import '../utilities/utilities.dart';
import '../widgets/compound/dialogs.dart';
import '../models/constants.dart';
import '../widgets/simple/button.dart';

import 'package:flutter/material.dart';

import 'homepage.dart';

class Verification extends StatefulWidget {
  static const routeName = '/verification';

  @override
  State<StatefulWidget> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final tokenController = new TextEditingController();
  final digit1 = new TextEditingController();
  final digit2 = new TextEditingController();
  final digit3 = new TextEditingController();
  final digit4 = new TextEditingController();
  final newPwd = new TextEditingController();
  final confirmPwd = new TextEditingController();
  int newToken = 0;

  Future<void> _verifyToken(BuildContext ctx) async {
    final Map<String, Object> args = ModalRoute.of(context).settings.arguments;
    //int token = args['token'];
    String email = args['email'];
    String page = args['page'];
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);
      var res = await AuthService.validateOtp(email, tokenController.text);
      if (res.statusCode == 200 && !res.body.contains('error')) {
        debugPrint('${res.body}');
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        if (page == 'SignUp')
          Navigator.pushNamedAndRemoveUntil(
              context, SignIn.routeName, (route) => false);
        else {
          //Navigate to Reset password screen
          Navigator.pushReplacementNamed(context, ResetPassword.routeName,
              arguments: email);
        }
      } else if (res.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Map<String, dynamic> error = jsonDecode(res.body);
        String errMsg = error['error'];
        ShowValidationMessage.showMessage(ctx, '$errMsg');
      } else {
        debugPrint('${res.statusCode} : ${res.body}');
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> args = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: double.infinity,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Verification',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05,
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              'Enter the verification code we just sent you on your email address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05,
                            ),
                            child: Container(
                              //margin: EdgeInsets.symmetric(horizontal: 20),
                              child: RegistrationInputField(
                                'Token',
                                controller: tokenController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     _verificationCodeField(context, '', digit1),
                            //     _verificationCodeField(context, '', digit2),
                            //     _verificationCodeField(context, '', digit3),
                            //     _verificationCodeField(context, 'Done', digit4),
                            //   ],
                            // ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                'If you didn\'t receive a code!',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.grey[400],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          //Resend Button
                          TextButton(
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              Dialogs.showLoadingDialog(context, _keyLoader);

                              //Send token to the email
                              await AuthService.generateOtp(
                                  args['email'].toString());

                              //Remove the loading icon after email has been sent
                              Navigator.of(_keyLoader.currentContext,
                                      rootNavigator: true)
                                  .pop();
                            },
                          ),

                          //Verify Button
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05,
                            ),
                            child: Button(
                              'VERIFY',
                              width: MediaQuery.of(context).size.width * 0.4,
                              onPressed: () => _verifyToken(context),
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

  @override
  void dispose() {
    digit1.dispose();
    digit2.dispose();
    digit3.dispose();
    digit4.dispose();
    newPwd.dispose();
    confirmPwd.dispose();
    super.dispose();
  }
}
