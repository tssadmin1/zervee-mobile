import '../../screens/item_details.dart';

import '../../utilities/utilities.dart';
import '../../models/card_item.dart';
import '../../models/constants.dart';
import 'package:flutter/material.dart';

class MyCardItem extends StatelessWidget {
  final CardItem myItem;
  const MyCardItem({
    Key key,
    this.myItem,
  }) : super(key: key);

  navigateToItemDetails(BuildContext context) {
    Navigator.of(context).pushNamed(ItemDetails.routeName, arguments: myItem);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToItemDetails(context),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 10, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Product Image
           Row(
             children: [
               (myItem.itemImages!=null && myItem.itemImages.isNotEmpty)?CircleAvatar(
                  backgroundImage: Utilities.getImage(myItem.itemImages[0]),
                ):CircleAvatar(
                  child: Text('No image',style: TextStyle(fontSize: 10,),),
                ),
                //Product Name and status
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myItem.itemName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(myItem.warrantyEndDate != null && myItem.warrantyEndDate.isNotEmpty)
                      Text(
                        DateTime.parse(myItem.warrantyEndDate).isBefore(DateTime.now().subtract(Duration(days: 1)))?'Warranty Expired':
                        'In Warranty',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
             ],
           ),

            //SizedBox(width: MediaQuery.of(context).size.width * 0.4),

            //Purchase Price and Date
            Column(
              children: [
                Text(
                  myItem.price,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.themeColorShade1,
                  ),
                ),
                Text(
                  myItem.purchaseDate,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}