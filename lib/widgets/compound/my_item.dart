import '../../utilities/utilities.dart';
import '../../models/card_item.dart';
import '../../screens/item_details.dart';
import 'package:flutter/material.dart';

class MyItem extends StatelessWidget {
  final CardItem item;

  MyItem(this.item);
  final textStyle = TextStyle(
    fontSize: 12,
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, ItemDetails.routeName, arguments: item),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Product/Item image
              Flexible(
                flex:1,
                child: Container(
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.0),
                  child: (item.itemImages != null && item.itemImages.isNotEmpty)
                      ? Image(image: Utilities.getImage(item.itemImages[0]))
                      : Text(
                          'No image',
                          style: TextStyle(fontSize: 10.0),
                        ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              //Few details of item
              Flexible(
                flex:2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Name: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: '${item.itemName}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ])),
                    SizedBox(height: 7),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Date of Purchase/Service: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: '${item.purchaseDate}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ])),
                    SizedBox(height: 7),
                    (item.serialNumber == null || item.serialNumber.isEmpty)
                        ? Container()
                        : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Serial Number: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: '${item.serialNumber}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
