import 'package:customerapp/webservices/FirebaseAuthService.dart';

import '../models/merchant_model.dart';

import '../webservices/AuthServices.dart';

import '../providers/user_info_provider.dart';

import '../models/user_info.dart';
import 'user_profile_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  static bool _isLoggedIn = false;
  static String _token;
  static DateTime _expiryDate;

  static UserProfile _userProfile;
  static final _facebookLogin = FacebookLogin();
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  static String get token {
    print('Fetching Token...' + DateTime.now().toIso8601String());
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      print('Fetched token : $_token');
      return _token;
    }
    return null;
  }

  static Future<bool> tryAutoLogin() async {
    print('trying to auto login...');
    try {
      print('Fetching data from shared preferences...');
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(AuthenticatedUser.key)) {
        print('Found stored shared prefs data...');
        final userData = JSON.jsonDecode(
            prefs.get(AuthenticatedUser.key)); // as Map<String, String>;
        print('Fetched user data from prefs ::: $userData');
        _token = userData['access_token'];
        _expiryDate = DateTime.parse(userData['expiry_date']);
        if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()))
          return true;

        //Try to refresh the token
        return await _refreshToken(userData);
      }
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  static Future<bool> _refreshToken(userData) async {
    print('Refreshing token');
    var res = await AuthService.resetToken(userData['refresh_token']);
    if (res.statusCode == 200) {
      await _saveToken(res);
      return true;
    }
    return false;
  }

  static Future<bool> loginWithGoogle() async {
    bool flag = true;
    print('Started google login...');
    try {
      await _googleSignIn.signIn();
      bool f = await _googleSignIn.isSignedIn();
      if (f) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'googleUserData',
            JSON.jsonEncode({
              'authHeaders': _googleSignIn.currentUser.authHeaders,
              'authentication': _googleSignIn.currentUser.authentication,
              'displayName': _googleSignIn.currentUser.displayName,
              'email': _googleSignIn.currentUser.email,
              'id': _googleSignIn.currentUser.id,
              'photoUrl': _googleSignIn.currentUser.photoUrl,
              'toString': _googleSignIn.currentUser.toString(),
            }));

        try {
          await logInWithEmail(
            _googleSignIn.currentUser.email,
            _googleSignIn.currentUser.email,
          );
        } catch (err) {
          print(
              'Something went wrong during user signin using Google Credentials...');
          print(err);
        }
        print('user logged in successfully using google credentials');
        print('Navigating to homepage...');
        //Navigator.pushReplacementNamed(context, '/');
      } else {
        flag = false;
        print('something went wrong with Google sign in...');
      }
    } catch (err) {
      flag = false;
    }
    return flag;
  }

  static Future<bool> loginWithFB() async {
    final result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final fbtoken = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$fbtoken');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('fbUserData', JSON.jsonEncode(profile));

        try {
          await logInWithEmail(
            profile['email'],
            profile['email'],
          );
        } catch (err) {
          print(
              'Something went wrong during user signup using FB credentials...');
          print(err);
        }
        print('user logged in successfully using FB credentials');
        print('Navigating to homepage...');
        //Navigator.pushReplacementNamed(context, '/');
        return true;

      case FacebookLoginStatus.cancelledByUser:
        _isLoggedIn = false;
        return false;
      case FacebookLoginStatus.error:
        _isLoggedIn = false;
        return false;
    }
    return _isLoggedIn;
  }

  static Future<void> logInWithEmail(String email, String password) async {
    try {
      print('Logging in with username and password');
      final res = await AuthService.signIn(email, password);
      if (res.statusCode == 200 && !res.body.contains('error')) {
        await _saveToken(res);
      } else {
        throw new Exception('${res.statusCode} : ${res.body.toString()}');
      }
    } catch (err) {
      throw err;
    }
  }

  static Future _saveToken(http.Response res) async {
    _isLoggedIn = true;
    Map<String, dynamic> json =
        JSON.jsonDecode(res.body) as Map<String, dynamic>;

    _token = json['access_token'];
    //APICalls.token = _token;
    _expiryDate = DateTime.now().add(Duration(seconds: json['expires_in']));
    final userDetails = AuthenticatedUser(
      accessToken: _token,
      expiryDate: _expiryDate.toIso8601String(),
      refreshToken: json['refresh_token'],
      scope: json['scope'],
      tokenType: json['token_type'],
    );
    print(json.toString());
    print(_token);
    print(_expiryDate);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        AuthenticatedUser.key, JSON.jsonEncode(userDetails.toJson()));
    if (_token.isNotEmpty) saveUserInfoInSharedPrefs();
  }

  static Future<String> signUpWithGoogle() async {
    print('Signing up with Google...');
    String flag;
    try {
      GoogleSignInAccount user = await _googleSignIn.signIn();
      bool f = await _googleSignIn.isSignedIn();
      if(!f)
        return 'Google Sign-in failed';
      print('${user.displayName}');
      print('${user.email}');
      print('${user.authHeaders}');
      print('${user.authentication}');
      print('${user.id}');
      print('${user.photoUrl}');
      print('${user.toString}');

      //bool f = await _googleSignIn.isSignedIn();
      if (f) {
        try {
          print('started user SignUp with google credentials');
          final res = await AuthService.signUp(
            email: _googleSignIn.currentUser.email,
            name: _googleSignIn.currentUser.displayName,
            password: _googleSignIn.currentUser.email,
            mobileNumber: '',
            signUpType: 'Google',
          );
          if (res.statusCode == 200) {
            if (!res.body.contains('error')) {
              print('user signed up successfully..using Google Credentials');
              await logInWithEmail(
                _googleSignIn.currentUser.email,
                _googleSignIn.currentUser.email,
              );
            } else if (res.body
                .toLowerCase()
                .contains('Already Exists'.toLowerCase())) {
              print('User already exists, signing in the user');
              flag = 'User already exists';
              await logInWithEmail(
                _googleSignIn.currentUser.email,
                _googleSignIn.currentUser.email,
              );
            }
          } else
            print('user signup failed..using google credentials');
        } catch (err) {
          print(
              'Something went wrong during user signup using Google Credentials...');
          print(err);
        }
        print('user logged in successfully using google credentials');
      } else {
        flag = 'something went wrong';
        print('something went wrong with Google sign in...');
      }
    } on Exception catch (err) {
      print(err);
      if (flag!=null && !flag.toLowerCase().contains('already exists')) flag = 'Exception';
    }
    return flag;
  }

  static Future<String> signUpWithFB() async {
    String msg = '';
    print('FB SignUp...');
    final result = await _facebookLogin.logIn(['email']);
    print('After login attempt...');
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final fbtoken = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$fbtoken');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('fbUserData', JSON.jsonEncode(profile));
        try {
          print('started user SignUp with FB credentials');
          final res = await AuthService.signUp(
            email: profile['email'],
            name: profile['name'],
            password: profile['email'],
            mobileNumber: '',
            signUpType: 'Facebook',
          );
          if (res.statusCode == 200) {
            if (!res.body.contains('error')) {
              print('user signed up successfully..using FB Credentials');
              await logInWithEmail(
                profile['email'],
                profile['email'],
              );
            } else if (res.body
                .toLowerCase()
                .contains('Already Exists'.toLowerCase())) {
              print('User already exists, signing in the user');
              msg = 'User already exists';
              await logInWithEmail(
                profile['email'],
                profile['email'],
              );
            }
          } else {
            print('user signup failed..using FB credentials');
            msg = '${res.body}';
          }
        } catch (err) {
          print(
              'Something went wrong during user signup using FB credentials...');
          print(err);
          if (!msg.toLowerCase().contains('Already exists'.toLowerCase()))
            msg = 'something went wrong';
        }
        print('user logged in successfully using FB credentials');
        print('Navigating to homepage...');
        return msg;

      case FacebookLoginStatus.cancelledByUser:
        _isLoggedIn = false;
        return '';
      case FacebookLoginStatus.error:
        _isLoggedIn = false;
        return '';
    }
    return msg;
  }

  static void logout() async {
    print("logout...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if(prefs.containsKey(Merchant.sharedPrefKey))
      prefs.remove(Merchant.sharedPrefKey);

    _token = '';
    _expiryDate = null;
    print('Successfully logged out...');
    FirebaseAuthService().signOut();
  }

  static UserProfile get userProfile {
    return _userProfile;
  }

  static bool get isLoggedIn {
    print('checking whether user is logged in...');

    return token != null;
  }

  static Future<void> saveUserInfoInSharedPrefs() async {
    print('saving user info to shared preferences...');
    final res = await AuthService.getUserInfo();
    if (res.statusCode == 200 && !res.body.contains('error')) {
      print('User info fetched successfully ::: ${res.body} ');
      var userInfo = userInfoFromJson(res.body);
      print('User info response parsed successfully:::$userInfo');
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(UserInfo.sharedPrefKey))
        prefs.remove(UserInfo.sharedPrefKey);

      print('Saving user info as ::: ${userInfoToJson(userInfo)}');
      prefs
          .setString(UserInfo.sharedPrefKey, userInfoToJson(userInfo))
          .then((value) {
        if (value) {
          print('UserInfo saved to shared preferences successfully');
          UserInfoProvider().fetchAndSetUserInfo();
        } else
          print('Saving user info failed....');
      });
    } else {
      print('User info could not be fetched from API');
      print('${res.statusCode} : ${res.body}');
    }
  }
}

class AuthenticatedUser {
  static const key = 'userData';

  final String accessToken;
  final String tokenType;
  final String refreshToken;
  final String expiryDate;
  final String scope;

  AuthenticatedUser({
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiryDate,
    this.scope = 'all',
  });

  Map<String, String> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'refresh_token': refreshToken,
      'expiry_date': expiryDate,
      'scope': scope,
    };
  }
}
