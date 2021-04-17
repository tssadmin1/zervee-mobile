// To parse this JSON data, do
//
//     final loyaltyCard = loyaltyCardFromJson(jsonString);

import 'dart:convert';

LoyaltyCard loyaltyCardFromJson(String str) => LoyaltyCard.fromJson(json.decode(str));

String loyaltyCardToJson(LoyaltyCard data) => json.encode(data.toJson());

class LoyaltyCard {
  static const String prefsKey = 'LoyaltyCardPrefsKey';
    LoyaltyCard({
        this.brandId,
        this.cardName,
        this.cardNumber,
        this.storeName,
        this.doNotCall,
        this.doNotMessage,
        this.userName,
        this.cardImage,
        this.cardId,
    });

    String brandId;
    String cardName;
    String cardNumber;
    String storeName;
    String doNotCall;
    String doNotMessage;
    String userName;
    String cardImage;
    String cardId;

    factory LoyaltyCard.fromJson(Map<String, dynamic> json) => LoyaltyCard(
        brandId: json["brandId"],
        cardName: json["cardName"],
        cardNumber: json["cardNumber"],
        storeName: json["storeName"],
        doNotCall: json["doNotCall"],
        doNotMessage: json["doNotMessage"],
        userName: json["userName"],
        cardImage: json["cardImage"],
        cardId: json["cardId"],
    );

    Map<String, dynamic> toJson() => {
        "brandId": brandId,
        "cardName": cardName,
        "cardNumber": cardNumber,
        "storeName": storeName,
        "doNotCall": doNotCall,
        "doNotMessage": doNotMessage,
        "userName": userName,
        "cardImage": cardImage,
        "cardId": cardId,
    };

    @override
  String toString() {
    return '''
    {
        "brandId": "$brandId",
        "cardName": "$cardName",
        "cardNumber": "$cardNumber",
        "storeName": "$storeName",
        "doNotCall": "$doNotCall",
        "doNotMessage": "$doNotMessage",
        "userName": "$userName",
        "cardImage": "$cardImage",
    }
    ''';
  }

  @override
  int get hashCode => cardId.hashCode;

  @override
  bool operator ==(Object m) => m is LoyaltyCard && cardId == m.cardId;
}