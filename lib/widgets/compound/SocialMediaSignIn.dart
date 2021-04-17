import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:customerapp/screens/homepage.dart';
import 'package:customerapp/webservices/FirebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../webservices/AuthServices.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import '../../utilities/utilities.dart';
import 'dialogs.dart';

import '../../models/auth_provider.dart';
import '../../models/constants.dart';

import 'package:flutter/material.dart';

class SocialMedialSignIn extends StatefulWidget {
  final GlobalKey<State> _keyLoader;
  //final bool isSignIn;
  SocialMedialSignIn(this._keyLoader);

  @override
  State<StatefulWidget> createState() {
    return _SocialMedialSignInState();
  }
}

class _SocialMedialSignInState extends State<SocialMedialSignIn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Horizontal line and text
        FittedBox(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                height: 1.0,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.grey[300],
              ),
              //Text between horizontal lines
              Text(
                ' Or ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                height: 1.0,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
        //Bottom content
        //Facebook button
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(1),
          margin: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300],
              width: 2.0,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(AppConstants.iconsFolder + 'facebook.png'),
                  height: 30,
                  width: 30,
                ),
                Text(
                  ' Facebook',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ],
            ),
            onPressed: () async {
              Dialogs.showNonDismissibleLoading(context);
              print('FB SignUp...');
              final result = await FacebookLogin().logIn(['email']);
              print('After login attempt...');
              if (result.status == FacebookLoginStatus.loggedIn) {
                final fbtoken = result.accessToken.token;
                final graphResponse = await http.get(Uri.parse(
                    'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$fbtoken'));
                final profile = JSON.jsonDecode(graphResponse.body);
                print(profile);
                print('-----------------------------------');
                print('---------${profile['name']}--------');
                print('-----------------------------------');
                var temp =
                    profile['email'] != null ? profile['email'] : profile['id'];

                await socialMediaSignUp(
                    profile['name'], temp, 'Facebook', context);

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(HomePage.routeName, (r) => false);
              } else if (result.status == FacebookLoginStatus.cancelledByUser) {
                //Navigator.pop(context);
                Utilities.showToastMessage('FB Loging cancelled');
              } else if (result.status == FacebookLoginStatus.error) {
                //Navigator.pop(context);
                print('-----------------------------------');
                print(result.errorMessage);
                //print(result);
                print('-----------------------------------');
                Utilities.showToastMessage('FB Loging Failed');
              } else {
                //Navigator.pop(context);
                Utilities.showToastMessage('Something went wrong');
              }
            },
          ),
        ),

        //Google
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(1),
          margin: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300],
              width: 2.0,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image:
                      AssetImage(AppConstants.iconsFolder + 'googleIcon.png'),
                  height: 30,
                  width: 30,
                ),
                Text(
                  '  Google',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ],
            ),
            onPressed: () {
              Dialogs.showLoadingDialog(context, widget._keyLoader);
              AuthProvider.signUpWithGoogle().then((value) {
                Navigator.of(widget._keyLoader.currentContext,
                        rootNavigator: true)
                    .pop();

                if (AuthProvider.isLoggedIn)
                  Navigator.of(context).pop();
                else {
                  if (value
                      .toLowerCase()
                      .contains('User already exists'.toLowerCase())) {
                    ShowValidationMessage.showMessage(context,
                        'Email already used, Please use forgot password');
                  } else {
                    if (value.isNotEmpty)
                      ShowValidationMessage.showMessage(context, '$value');
                    else
                      ShowValidationMessage.showMessage(
                          context, 'Google Login failed');
                  }
                }
              });
            },
          ),
        ),

        //Apple
        if (Platform.isIOS)
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300],
                width: 2.0,
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image:
                        AssetImage(AppConstants.iconsFolder + 'apple_icon.png'),
                    height: 40,
                    width: 40,
                  ),
                  Text(
                    '  Apple',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ],
              ),
              onPressed: () async {
                Dialogs.showNonDismissibleLoading(context);
                if (!await AppleSignIn.isAvailable()) {
                  Navigator.pop(context);
                  Utilities.showToastMessage(
                      'Apple SignIn is not available on this device');
                  return;
                }
                User user;
                try {
                  AuthorizationCredentialAppleID credential =
                      await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );
                  final OAuthProvider oAuthProvider =
                      OAuthProvider('apple.com');
                  final credentialForFirebase = oAuthProvider.credential(
                    idToken: credential.identityToken,
                    accessToken: credential.authorizationCode,
                  );

                  final firebaseRes = await FirebaseAuthService()
                      .signinWithCredential(credentialForFirebase);
                  user = firebaseRes.user;
                  print(user.email);
                  print(user.displayName);
                  print(user.uid);
                } on Exception catch (e) {
                  print(e);
                  Utilities.showToastMessage(e.toString());
                } finally {
                  if (user != null) {
                    var email = user.email;
                    print("$email");

                    socialMediaSignUp(
                        '${user.displayName}', email, 'Apple', context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomePage.routeName, (r) => false);
                  } else {
                    print('Login cancelled or failed');
                    //Navigator.pop(context);
                    await Utilities.showToastMessage("Apple Login Cancelled");
                  }
                }
              },
            ),
          ),
      ],
    );
  }

  Future socialMediaSignUp(String name, String email, String signUptype,
      BuildContext context) async {
    print('started user SignUp with $signUptype credentials');
    String msg;
    final res = await AuthService.signUp(
      email: email,
      name: name,
      password: email,
      mobileNumber: '',
      signUpType: '$signUptype',
    );
    if (res.statusCode == 200) {
      if (!res.body.contains('error')) {
        print('login using $signUptype Credentials');
        await AuthProvider.logInWithEmail(
          email,
          email,
        );
      } else if (res.body
          .toLowerCase()
          .contains('Already Exists'.toLowerCase())) {
        await AuthProvider.logInWithEmail(
          email,
          email,
        );
        if (!AuthProvider.isLoggedIn) {
          msg = 'Email already used, please use forgot password';
        }
      }
    } else {
      print('user signup failed..using $signUptype credentials');
      msg = res.reasonPhrase;
    }
    Navigator.pop(context);
    if (msg != null && msg.isNotEmpty) Utilities.showToastMessage(msg);
  } //ends socialMediaSignUp
}
