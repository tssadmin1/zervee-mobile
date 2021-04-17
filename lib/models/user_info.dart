// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  static const String sharedPrefKey = 'UserInfo';
  UserInfo({
    this.name,
    this.phoneNumber,
    this.location,
    this.title,
    this.signUpType,
    this.email,
    this.username,
    this.brandNames,
    this.productIds,
    this.dateOfBirth,
    this.sex,
    this.country,
    this.customerAddress,
    this.deliveryAdderess,
    this.id,
    this.joiningDate,
    this.roles,
  });

  String name;
  String phoneNumber;
  String location;
  String title;
  String signUpType;
  String email;
  String username;
  dynamic brandNames;
  dynamic productIds;
  dynamic dateOfBirth;
  String sex;
  String country;
  String customerAddress;
  String deliveryAdderess;
  String id;
  int joiningDate;
  List<String> roles;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        location: json["location"],
        title: json["title"],
        signUpType: json["signUpType"],
        email: json["email"],
        username: json["username"],
        brandNames: json["brandNames"],
        productIds: json["productIds"],
        dateOfBirth: json["dateOfBirth"],
        sex: json["sex"],
        country: json["country"],
        customerAddress: json["customerAddress"],
        deliveryAdderess: json["deliveryAdderess"],
        id: json["id"],
        joiningDate: json["joiningDate"],
        roles: List<String>.from(json["roles"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "location": location,
        "title": title,
        "signUpType": signUpType,
        "email": email,
        "username": username,
        "brandNames": brandNames,
        "productIds": productIds,
        "dateOfBirth": dateOfBirth,
        "sex": sex,
        "country": country,
        "customerAddress": customerAddress,
        "deliveryAdderess": deliveryAdderess,
        "id": id,
        "joiningDate": joiningDate,
        "roles": List<dynamic>.from(roles.map((x) => x)),
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object m) => m is UserInfo && id == m.id;
}
