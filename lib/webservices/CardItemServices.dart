import '../models/constants.dart';
import '../models/auth_provider.dart';
import '../models/card_item.dart';
import 'package:http/http.dart' as http;

class CardItemService {
  static String baseUrl = AppConstants.custServiceUrl;
  
  static Future<http.Response> addCardItem(CardItem item) async {
    var url = baseUrl + '/carditems';
    print('calling api : $url');
    var token = AuthProvider.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = cardItemToJson(item);
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

  static Future<http.Response> editCardItem(CardItem item) async {
    var url = baseUrl + '/carditems';
    print('calling api : $url');
    var token = AuthProvider.token;
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse(url));
    print('--------------------------------');
    print('''"cardId": "${item.cardId}",
        "itemName": "${item.itemName}",
        "purchaseDate": "${item.purchaseDate}",
        "price": "${item.price}",
        "serialNumber": "${item.serialNumber}",
        "userName": "${item.userName}",
        "itemImages": [${item.itemImages.length}],
        "proofOfPurchaseFiles": [${item.proofOfPurchaseFiles.length}],
        "itemId": "${item.itemId}",
        "status": "${item.status}",
        "warrantyStartDate": "${item.warrantyStartDate}",
        "warrantyEndDate": "${item.warrantyEndDate}"''');
    print('--------------------------------');
    request.body = cardItemToJson(item);
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

  static Future<http.Response> deleteCardItem(String itemId) async {
    var url = baseUrl + '/carditems/$itemId';
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

  static Future<http.Response> getCardItems(String userName) async {
    var url = baseUrl + '/carditems?username=$userName';
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