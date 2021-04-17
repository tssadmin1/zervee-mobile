import 'dart:async';
import '../models/constants.dart';

import '../models/auth_provider.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static var baseUrl = AppConstants.authServiceUrl;
  static var customerBaseUrl = AppConstants.custServiceUrl;

  static Future<http.Response> generateOtp(String email) async {
    String url = baseUrl + '/otp/generate';
    print('calling api : $url');
    print('Email : $email');
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
      'POST',
      //Uri.parse('esme6u7phh.execute-api.us-east-1.amazonaws.com/otp/generate'),
      Uri.parse(url),
    );
    request.body = '''{\r\n    "email" : "$email"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> signIn(String email, String pwd) async {
    String url = baseUrl + '/token';
    print('calling API : $url');
    var headers = {
      'Authorization': 'Basic cm9raW4tY2xpZW50OnNlY3JldA==',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
      'POST',
      //Uri.parse('esme6u7phh.execute-api.us-east-1.amazonaws.com/dev/token'),
      Uri.parse(url),
    );
    request.bodyFields = {
      'grant_type': 'password',
      'username': email,
      'password': pwd,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> signUp({
    String name,
    String email,
    String mobileNumber,
    String password,
    String signUpType,
  }) async {
    String url = baseUrl + '/signup';
    print('calling API : $url');
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      //Uri.parse('esme6u7phh.execute-api.us-east-1.amazonaws.com/dev/signup'),
      Uri.parse(url),
    );
    var userName = email.replaceAll(new RegExp('\\.'), '_');
    print('$userName');
    request.body = '''{
        "name": "$name",
        "username": "$userName",
        "email": "$email",
        "mobileNumber":"$mobileNumber",
        "signUpType":"$signUpType",
        "password": "$password",
        "roles": ["ROLE_MOBILE_CLIENT"]
    }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print('${response.statusCode} : ${response.reasonPhrase}');
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> validateOtp(String email, String otp) async {
    String url = baseUrl + '/otp/validate';
    print('calling API : $url');
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      //Uri.parse('esme6u7phh.execute-api.us-east-1.amazonaws.com/otp/validate'),
      Uri.parse(url),
    );
    request.body = '''{\n    "email" : "$email",\n    "otp" : "$otp"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> resetPassword(String email, String pwd) async {
    String url = baseUrl + '/resetpassword';
    print('calling API : $url');
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      //Uri.parse('esme6u7phh.execute-api.us-east-1.amazonaws.com/resetpassword'),
      Uri.parse(url),
    );
    request.body =
        '''{\r\n    "email":"$email",\r\n    "password":"$pwd"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> getUserInfo() async {
    String url = customerBaseUrl + '/users';
    print('Calling API : $url');
    var token = AuthProvider.token;
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
      'GET',
      Uri.parse(url),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> resetToken(String refreshToken) async {
    String url = baseUrl + '/token';
    print('calling API : $url');
    var headers = {
      'Authorization': 'Basic cm9raW4tY2xpZW50OnNlY3JldA==',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
      'POST',
      //Uri.parse('esme6u7phh.execute-api.us-east-1.amazonaws.com/dev/token'),
      Uri.parse(url),
    );
    request.bodyFields = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('API call finished for : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }


}
