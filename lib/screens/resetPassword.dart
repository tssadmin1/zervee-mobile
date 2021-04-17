import '../screens/SignIn.dart';
import '../screens/forgotPassword.dart';
import '../utilities/utilities.dart';
import '../webservices/AuthServices.dart';
import '../widgets/compound/dialogs.dart';

import '../models/constants.dart';
import '../widgets/compound/registrationInputField.dart';
import '../widgets/simple/button.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class ResetPassword extends StatefulWidget {
  static const String routeName = '/reset_password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _resetForm = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final newPwdController = TextEditingController();

  final confirmPwdController = TextEditingController();

  bool showPwd = true;
  bool showConfirmPwd = true;

  Future<void> _resetPassword(BuildContext context, String email) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    var res = await AuthService.resetPassword(email, newPwdController.text);
    if (res.statusCode == 200 && !res.body.contains('error')) {
      debugPrint('${res.body}');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ShowValidationMessage.showMessage(
          context, 'Password has been reset successfully');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushNamedAndRemoveUntil(
          context, SignIn.routeName, (route) => false);
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      debugPrint('${res.body}');
      ShowValidationMessage.showMessage(
          context, 'Something went wrong! Please try again');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, ForgotPassword.routeName);
    }
  }

  void _saveForm(BuildContext ctx, String email) {
    if (_resetForm.currentState.validate()) {
      debugPrint('Resetting password for email : $email');
      _resetPassword(ctx, email);
    } else {
      print('Form validation failed...');
    }
  }

  String _passwordValidation(String value) {
    if (value.length < 8) return 'At least 8 characters';
    bool flag = value.contains(RegExp(AppConstants.pwdPolicies[1])) &&
        value.contains(RegExp(AppConstants.pwdPolicies[2])) &&
        value.contains(RegExp(AppConstants.pwdPolicies[3]));
    if (flag) return null;
    return 'Requires at least 1 uppercase char, 1 lowercase char, 1 digit';
  }

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _resetForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Image.asset(
                        AppConstants.imagesFolder + 'ResetPasswordImage.png',
                        height: 200,
                        width: 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your mail is confirmed for new password. Let’s change the password.',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 30),
                      RegistrationInputField(
                        'New Password',
                        controller: newPwdController,
                        obscureText: showPwd,
                        validator: (value) {
                          return _passwordValidation(value);
                        },
                        suffixIcon: IconButton(
                          icon: showPwd
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
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
                      SizedBox(height: 20),
                      RegistrationInputField(
                        'Confirm Password',
                        controller: confirmPwdController,
                        validator: (value) {
                          return value == newPwdController.text
                              ? null
                              : 'Password does not match';
                        },
                        obscureText: showConfirmPwd,
                        suffixIcon: IconButton(
                          icon: showConfirmPwd
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            setState(
                              () {
                                print('show/hide pwd');
                                showConfirmPwd = !showConfirmPwd;
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Button(
                        'Done',
                        onPressed: () => _saveForm(context, email),
                      ),
                      SizedBox(height: 20),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
