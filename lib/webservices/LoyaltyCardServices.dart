import '../models/constants.dart';

import '../models/auth_provider.dart';
import '../models/loyalty_card_model.dart';
import 'package:http/http.dart' as http;

class LoyaltyCardService {
  static String baseUrl = AppConstants.custServiceUrl;

  static Future<http.Response> addCard(LoyaltyCard card) async {
    //var url = baseUrl + '/loyaltycards/add';
    var url = baseUrl + '/cards';
    var token = AuthProvider.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = loyaltyCardToJson(card);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> editCard(LoyaltyCard card) async {
    var url = baseUrl + '/cards';
    print('calling api : $url');
    var token = AuthProvider.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = loyaltyCardToJson(card);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> deleteCard(String cardId) async {
    var url = baseUrl + '/cards/$cardId';
    print('calling api : $url');
    var token = AuthProvider.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('DELETE', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      print(response.stream);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }

  static Future<http.Response> getCards(String userName) async {
    //var url = baseUrl + '/loyaltycards/get/byusername/$userName';
    var url = baseUrl + '/cards?username=$userName';
    print('calling api : $url');
    var token = AuthProvider.token;
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('API call finished : $url');
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      return http.Response(res, 200);
    } else {
      print(response.reasonPhrase);
      return http.Response(response.reasonPhrase, response.statusCode);
    }
  }
  
}