// To parse this JSON data, do
//
//     final advertisement = advertisementFromJson(jsonString);

import 'dart:convert';

Advertisement advertisementFromJson(String str) => Advertisement.fromJson(json.decode(str));

String advertisementToJson(Advertisement data) => json.encode(data.toJson());

class Advertisement {
  static const sharedPrefsKey = 'AllAdvertisements';
    Advertisement({
        this.id,
        this.adminUserEmail,
        this.zerveeAssociatedProductId,
        this.advertisementName,
        this.advertisementDescription,
        this.advertisementStartDate,
        this.advertisementEndDate,
        this.advertisementStatus,
        this.advertisementImage,
        this.displayType,
        this.url,
    });

    String id;
    String adminUserEmail;
    String zerveeAssociatedProductId;
    String advertisementName;
    String advertisementDescription;
    String advertisementStartDate;
    String advertisementEndDate;
    String advertisementStatus;
    String advertisementImage;
    String displayType;
    String url;

    factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
        id: json["id"],
        adminUserEmail: json["adminUserEmail"],
        zerveeAssociatedProductId: json["zerveeAssociatedProductId"],
        advertisementName: json["advertisementName"],
        advertisementDescription: json["advertisementDescription"],
        advertisementStartDate: json["advertisementStartDate"],
        advertisementEndDate: json["advertisementEndDate"],
        advertisementStatus: json["advertisementStatus"],
        advertisementImage: json["advertisementImage"],
        displayType: json["displayType"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "adminUserEmail": adminUserEmail,
        "zerveeAssociatedProductId": zerveeAssociatedProductId,
        "advertisementName": advertisementName,
        "advertisementDescription": advertisementDescription,
        "advertisementStartDate": advertisementStartDate,
        "advertisementEndDate": advertisementEndDate,
        "advertisementStatus": advertisementStatus,
        "advertisementImage": advertisementImage,
        "displayType": displayType,
        "url": url,
    };
  
    @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object m) => m is Advertisement && id==m.id;
}
