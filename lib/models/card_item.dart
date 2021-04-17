import 'dart:convert';

CardItem cardItemFromJson(String str) => CardItem.fromJson(json.decode(str));

String cardItemToJson(CardItem data) => json.encode(data.toJson());

class CardItem {
  static const String cardItemPrefsKey = "CardItemPrefsKey";
  CardItem({
    this.cardId,
    this.itemName,
    this.purchaseDate,
    this.price,
    this.serialNumber,
    this.userName,
    this.itemImages,
    this.proofOfPurchaseFiles,
    this.itemId,
    this.status,
    this.warrantyStartDate,
    this.warrantyEndDate,
  });

  String cardId;
  String itemName;
  String purchaseDate;
  String price;
  String serialNumber;
  String userName;
  List<String> itemImages;
  List<String> proofOfPurchaseFiles;
  String itemId;
  String status;
  String warrantyStartDate;
  String warrantyEndDate;

  factory CardItem.fromJson(Map<String, dynamic> json) {
    var startDate, endDate;
    if(json["warrantyStartDate"]!=null && json["warrantyStartDate"].toString().isNotEmpty && json["warrantyStartDate"].toString().contains('/')) {
      var temp =json["warrantyStartDate"].toString().split('/');
      print('$temp');
      startDate = '${temp[2]}-${temp[1]}-${temp[0]}';
    }
    if(json["warrantyEndDate"]!=null && json["warrantyEndDate"].toString().isNotEmpty && json["warrantyEndDate"].toString().contains('/')) {
      var temp =json["warrantyEndDate"].toString().split('/');
      print('$temp');
      endDate = '${temp[2]}-${temp[1]}-${temp[0]}';
    }
    return CardItem(
      cardId: json["cardId"],
      itemName: json["itemName"],
      purchaseDate: json["purchaseDate"],
      price: json["price"],
      serialNumber: json["serialNumber"],
      userName: json["userName"],
      itemImages: List<String>.from(json["itemImages"].map((x) => x)),
      proofOfPurchaseFiles:
          List<String>.from(json["proofOfPurchaseFiles"].map((x) => x)),
      itemId: json["itemId"],
      status: json["status"],
      warrantyStartDate: startDate!=null?startDate:json["warrantyStartDate"],
      warrantyEndDate: endDate!=null?endDate:json["warrantyEndDate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "cardId": cardId,
        "itemName": itemName,
        "purchaseDate": purchaseDate,
        "price": price,
        "serialNumber": serialNumber,
        "userName": userName,
        "itemImages": List<dynamic>.from(itemImages.map((x) => x)),
        "proofOfPurchaseFiles":
            List<dynamic>.from(proofOfPurchaseFiles.map((x) => x)),
        "itemId": itemId,
        "status": status,
        "warrantyStartDate": warrantyStartDate,
        "warrantyEndDate": warrantyEndDate,
      };

  @override
  int get hashCode => itemId.hashCode;

  @override
  bool operator ==(Object m) => m is CardItem && itemId == m.itemId;
}