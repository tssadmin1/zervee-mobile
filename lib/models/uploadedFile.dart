// To parse this JSON data, do
//
//     final uploadedFile = uploadedFileFromJson(jsonString);

import 'dart:convert';

FileUploadResponse uploadedFileFromJson(String str) => FileUploadResponse.fromJson(json.decode(str));

String uploadedFileToJson(FileUploadResponse data) => json.encode(data.toJson());

class FileUploadResponse {
    FileUploadResponse({
        this.status,
        this.errorMessage,
        this.errorCode,
        this.data,
    });

    String status;
    dynamic errorMessage;
    dynamic errorCode;
    String data;

    factory FileUploadResponse.fromJson(Map<String, dynamic> json) => FileUploadResponse(
        status: json["status"],
        errorMessage: json["errorMessage"],
        errorCode: json["errorCode"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "errorMessage": errorMessage,
        "errorCode": errorCode,
        "data": data,
    };
}