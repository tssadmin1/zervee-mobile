import '../../screens/forgotPassword.dart';
import '../simple/customTextField.dart';

import 'package:flutter/material.dart';

class SignInInputFields extends StatefulWidget {
  final TextEditingController _email;
  final TextEditingController _pwd;
  SignInInputFields(this._email, this._pwd);

  @override
  _SignInInputFieldsState createState() => _SignInInputFieldsState();
}

class _SignInInputFieldsState extends State<SignInInputFields> {
  void _navigateToForgotPassword(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(ForgotPassword.routeName);
  }

  bool showPwd = false;
  double fontSize = 16;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomTextField(
                    hintText: 'Email',
                    width: MediaQuery.of(context).size.width * 0.8,
                    controller: widget._email,
                    fontSize: fontSize,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    fontSize: fontSize,
                    width: MediaQuery.of(context).size.width * 0.8,
                    obscureText: !showPwd,
                    obscuringChar: '*',
                    controller: widget._pwd,
                    suffixIcon: IconButton(
                      icon: showPwd
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          print('show/hide pwd');
                          showPwd = !showPwd;
                        });
                      },
                    ),
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () => _navigateToForgotPassword(context),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
