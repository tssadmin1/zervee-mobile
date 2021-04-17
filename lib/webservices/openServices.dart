import '../models/constants.dart';
import 'package:http/http.dart' as http;

class OpenService {
  static String baseUrl = AppConstants.adminServiceUrl;
  
  static Future<http.Response> getMerchants() async {
    String url = baseUrl + '/merchant/list';
    print('Calling API : $url');
    var request = http.Request(
        'GET', Uri.parse(url));

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
  
  static Future<http.Response> getAdvertisements() async {
    String url = baseUrl + '/advertisements/list';
    print('Calling API : $url');
    var request = http.Request(
        'GET', Uri.parse(url));

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