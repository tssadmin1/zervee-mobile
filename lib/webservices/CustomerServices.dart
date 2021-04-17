import 'dart:io';
import '../models/constants.dart';

import '../models/uploadedFile.dart';
import '../models/auth_provider.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static var _mimeTypes = {
    'png': 'image/jpeg',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  };
  
  static Future<String> uploadFile(String filePath) async {
    print('Started file upload...');
    var fileExtension = filePath.split('.').last;
    var mimeType = _mimeTypes[fileExtension].toString();
    var headers = {
      'Authorization': 'Bearer ${AuthProvider.token}',
      'Content-Type': mimeType,
    };
    print('$headers');
    
    print('Mime Type : ' + mimeType);
    print('File Path : $filePath');
    var url =
        Uri.parse( '${AppConstants.custServiceUrl}/storage/uploadFile?type=$fileExtension');
    print('using direct post method');
    print('$url');
    var response = await http.post(
      url,
      headers: headers,
      body: File(filePath).readAsBytesSync(),
    );
    
    print('File Upload finished');
    if (response.statusCode == 200) {
      print(response.body);
      var fileUrl = uploadedFileFromJson(response.body).data;
      print('$fileUrl');
      return fileUrl;
    } else {
      print('Upload failed ::::: ${response.body}');
      return 'upload failed';
    }
  }


}