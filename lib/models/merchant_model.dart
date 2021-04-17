// To parse this JSON data, do
//
//     final merchant = merchantFromJson(jsonString);

import 'dart:convert';

Merchant merchantFromJson(String str) => Merchant.fromJson(json.decode(str));

String merchantToJson(Merchant data) => json.encode(data.toJson());

class Merchant {
  static const String sharedPrefKey = 'merchants';
  Merchant({
    this.brandName,
    this.location,
    this.brandIconImage,
    this.brandCardImage,
    this.industryCategory,
    this.subDomain,
    this.email,
    this.phone,
    this.employeeRange,
    this.websiteLink,
    this.industry,
    this.registrationNo,
    this.street,
    this.town,
    this.state,
    this.country,
    this.userId,
    this.userName,
    this.subscriptionType,
    this.tax,
    this.approval,
    this.id,
    this.zerveeBrandId,
    this.createDate,
    this.modifiedDate,
    this.createBy,
    this.modifiedBy,
    this.brandAdmins,
    this.registerationNo,
  });

  String brandName;
  String location;
  String brandIconImage;
  String brandCardImage;
  dynamic industryCategory;
  String subDomain;
  String email;
  String phone;
  String employeeRange;
  String websiteLink;
  String industry;
  String registrationNo;
  String street;
  String town;
  String state;
  String country;
  String userId;
  dynamic userName;
  String subscriptionType;
  String tax;
  bool approval;
  String id;
  String zerveeBrandId;
  String createDate;
  String modifiedDate;
  dynamic createBy;
  dynamic modifiedBy;
  List<dynamic> brandAdmins;
  String registerationNo;

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        brandName: json["brandName"],
        location: json["location"],
        brandIconImage: json["brandIconImage"],
        brandCardImage: json["brandCardImage"],
        industryCategory: json["industryCategory"],
        subDomain: json["subDomain"],
        email: json["email"],
        phone: json["phone"],
        employeeRange: json["employeeRange"],
        websiteLink: json["websiteLink"],
        industry: json["industry"],
        registrationNo: json["registrationNo"],
        street: json["street"],
        town: json["town"],
        state: json["state"],
        country: json["country"],
        userId: json["userId"],
        userName: json["userName"],
        subscriptionType: json["subscriptionType"],
        tax: json["tax"],
        approval: json["approval"],
        id: json["id"],
        zerveeBrandId: json["zerveeBrandId"],
        createDate: json["createDate"],
        modifiedDate: json["modifiedDate"],
        createBy: json["createBy"],
        modifiedBy: json["modifiedBy"],
        brandAdmins: List<dynamic>.from(json["brandAdmins"].map((x) => x)),
        registerationNo: json["registerationNo"],
      );

  Map<String, dynamic> toJson() => {
        "brandName": brandName,
        "location": location,
        "brandIconImage": brandIconImage,
        "brandCardImage": brandCardImage,
        "industryCategory": industryCategory,
        "subDomain": subDomain,
        "email": email,
        "phone": phone,
        "employeeRange": employeeRange,
        "websiteLink": websiteLink,
        "industry": industry,
        "registrationNo": registrationNo,
        "street": street,
        "town": town,
        "state": state,
        "country": country,
        "userId": userId,
        "userName": userName,
        "subscriptionType": subscriptionType,
        "tax": tax,
        "approval": approval,
        "id": id,
        "zerveeBrandId": zerveeBrandId,
        "createDate": createDate,
        "modifiedDate": modifiedDate,
        "createBy": createBy,
        "modifiedBy": modifiedBy,
        "brandAdmins": List<dynamic>.from(brandAdmins.map((x) => x)),
        "registerationNo": registerationNo,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object m) => m is Merchant && id == m.id;
}
