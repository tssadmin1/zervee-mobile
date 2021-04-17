import '../widgets/compound/registrationInputField.dart';
import '../widgets/simple/button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/auth_provider.dart';
import '../widgets/compound/dialogs.dart';
import '../widgets/compound/LogoWithText_Header.dart';
import '../widgets/compound/SocialMediaSignIn.dart';
import '../utilities/utilities.dart';
import 'SignUp.dart';
import 'forgotPassword.dart';
import 'homepage.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/sign-in';
  //static String nextPageRoute = '/';
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final _form = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController pwd = new TextEditingController();
  bool showPwd = false;

  @override
  void dispose() {
    debugPrint('Dispose from SignIn screen');
    email.dispose();
    pwd.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext ctx) async {
    print('Sign-in started...');
    Dialogs.showLoadingDialog(context, _keyLoader);
    try {
      await AuthProvider.logInWithEmail(email.text.trim(), pwd.text.trim());
      if (AuthProvider.isLoggedIn) {
        print('Successfully signed-in...Navigating to HomePage...');
        await AuthProvider.saveUserInfoInSharedPrefs();
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        _navigateToBack(ctx);
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        ShowValidationMessage.showMessage(
            ctx, 'Either username or password is incorrect');
      }
    } catch (err) {
      print(err);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      ShowValidationMessage.showMessage(
          ctx, 'Either username or password is incorrect');
    }
  }

  void _navigateToBack(BuildContext ctx) {
    print('Navigating to home page');
    Navigator.pushNamedAndRemoveUntil(
        context, HomePage.routeName, (route) => false);
  }

  void _saveForm(BuildContext context) {
    if (_form.currentState.validate()) _signIn(context);
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
                        //space before actual content
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        // Zervee logo
                        FittedBox(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: LogoWithTextHeader(''),
                          ),
                        ),

                        //Sign in form
                        Form(
                          key: _form,
                          //autovalidateMode: AutovalidateMode.always,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RegistrationInputField(
                                  'Email id',
                                  controller: email,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                RegistrationInputField(
                                  'Password',
                                  obscureText: !showPwd,
                                  controller: pwd,
                                  suffixIcon: IconButton(
                                    icon: showPwd
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        print('show/hide pwd');
                                        showPwd = !showPwd;
                                      });
                                    },
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Cannot be empty';
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            ForgotPassword.routeName);
                                      },
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                            color: Colors.accents.first),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Button(
                                  'SIGN IN',
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  onPressed: () => _saveForm(context),
                                ),
                                SizedBox(height: 20),
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
                                        text: 'New User ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15)),
                                    TextSpan(
                                        text: 'Sign-up',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context)
                                                .pushNamed(SignUp.routeName);
                                          },
                                        style: TextStyle(
                                          color: Colors.accents.first,
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ])),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _navigateToBack(context),
                    ),
                    top:1,
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