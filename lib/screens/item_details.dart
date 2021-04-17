import '../screens/photo_preview.dart';

import '../providers/item_provider.dart';
import '../widgets/compound/dialogs.dart';

import '../providers/loyalty_card_provider.dart';
import 'package:provider/provider.dart';

import '../utilities/utilities.dart';

import '../widgets/simple/settings_button.dart';
import '../models/card_item.dart';
import '../models/constants.dart';
import '../widgets/compound/bottomNavigationBar.dart';
import 'package:flutter/material.dart';

import 'add_item.dart';

class ItemDetails extends StatefulWidget {
  static const routeName = '/itemDetails';

  @override
  State<StatefulWidget> createState() {
    return _ItemDetailsState();
  }
}

class _ItemDetailsState extends State<ItemDetails> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void dispose() {
    print('Item Details dispose...');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    final CardItem tmpItem =
        ModalRoute.of(context).settings.arguments as CardItem;
    final CardItem item =
        Provider.of<ItemProvider>(context).getItemById(tmpItem.itemId);
    final String brand =
        Provider.of<LoyaltyCardProvider>(context, listen: false)
            .getBrandNameForCardId(item.cardId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.primaryColor),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Product Details',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          SettingsButton(),
        ],
      ),
      body: SafeArea(
        child: Builder(
          builder: (ctx) => Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Container(
                      //height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(ctx).size.width * 0.93,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FittedBox(
                        child: Stack(
                          //overflow: Overflow.visible,
                          clipBehavior: Clip.antiAlias,
                          children: [
                            Column(
                              children: [
                                //Product Name and brand
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Item name
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        'Product Name: ${item.itemName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    //Brand name
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        'Brand: $brand',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),

                                //Item Images
                                _displayImage(item),
                                //Space between images and other details
                                SizedBox(
                                  height: MediaQuery.of(ctx).size.height * 0.05,
                                ),

                                //Other details of the item
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      //Date of purchase/service
                                      Container(
                                        width:
                                            MediaQuery.of(ctx).size.width * 0.9,
                                        alignment: Alignment.centerLeft,
                                        child: Utilities.showLabelAndText(
                                            'Date of Purchase/Service: ',
                                            item.purchaseDate),
                                        //Text('Date of Purchase/Service: ${item.purchaseDate}'),
                                        margin: EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                      ),

                                      //Serial Number
                                      (item.serialNumber == null ||
                                              item.serialNumber.isEmpty)
                                          ? Container()
                                          : Container(
                                              width: MediaQuery.of(ctx)
                                                      .size
                                                      .width *
                                                  0.9,
                                              alignment: Alignment.centerLeft,
                                              child: Utilities.showLabelAndText(
                                                  'Serial Number: ',
                                                  item.serialNumber),
                                              margin: EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                            ),

                                      //Price
                                      if (item.price != null &&
                                          item.price.isNotEmpty)
                                        Container(
                                          width: MediaQuery.of(ctx).size.width *
                                              0.9,
                                          alignment: Alignment.centerLeft,
                                          child: Utilities.showLabelAndText(
                                              'Price: ', item.price),
                                        ),

                                      //Warranty
                                      if (item.warrantyEndDate != null &&
                                          item.warrantyEndDate.isNotEmpty)
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: MediaQuery.of(ctx).size.width *
                                              0.9,
                                          alignment: Alignment.centerLeft,
                                          child: Utilities.showLabelAndText(
                                              'Warranty - Expiry Date : ',
                                              item.warrantyEndDate),
                                        ),
                                      //SizedBox(height: 20),
                                    ],
                                  ),
                                ),

                                if (item.proofOfPurchaseFiles != null &&
                                    item.proofOfPurchaseFiles.isNotEmpty)
                                  Container(
                                    width: MediaQuery.of(ctx).size.width * 0.9,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                          text: 'Proof of purchase : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )),
                                        ...item.proofOfPurchaseFiles.map((e) =>
                                            GestureDetector(
                                              onTap: () {
                                                var ext = e.split('.').last;
                                                if(ext=='jpg' || ext=='jpeg' || ext=='png')
                                                  openImage(context, e);
                                                else Utilities.launchURL(e);
                                                
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(left: 8.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        Utilities.getImage(e),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  )
                              ],
                            ),
                            //Edit Icon
                            Positioned(
                              top: -15,
                              right: -15,
                              child: IconButton(
                                icon: ImageIcon(
                                  Image.asset(
                                    AppConstants.iconsFolder + 'edit.png',
                                  ).image,
                                  color: AppConstants.themeColorShade1,
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pushNamed(AddItem.routeName,
                                      arguments: item);
                                },
                              ),
                            ),
                            //delete icon
                            Positioned(
                              bottom: -15,
                              right: -15,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppConstants.themeColorShade1,
                                ),
                                onPressed: () => _deleteItem(ctx, item),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ZerveeBottonNavigationBar(
                  selectedIndex: 5,
                  onAddPressed: () {
                    Navigator.of(ctx).pushNamed(AddItem.routeName);
                  },
                  isAddItem: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openImage(BuildContext context, String e) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(
            name: PhotoPreview
                .routeName),
        builder: (context) =>
            PhotoPreview(
          Utilities.getImage(e),
        ),
      ),
    );
  }

  void openFile(BuildContext context, String e) {
    Utilities.launchURL(e);
  }

  void _deleteItem(BuildContext context, CardItem item) async {
    print('Dismissed');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Warning!'),
              content: Text('Do you really want to delete?'),
              actions: [
                //Yes Button
                TextButton(
                    onPressed: () async {
                      Dialogs.showLoadingDialog(context, _keyLoader);
                      String msg = await Provider.of<ItemProvider>(context,
                              listen: false)
                          .deleteItem(item.itemId);
                      Navigator.of(_keyLoader.currentContext,
                              rootNavigator: true)
                          .pop();
                      ShowValidationMessage.showMessage(context, msg);
                      Future.delayed(Duration(seconds: 1));
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes')),

                //No button
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('No')),
              ],
            ));
  }

  Widget _displayImage(CardItem item) {
    if (item.itemImages.length == 1)
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.height * 0.2,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: RouteSettings(name: PhotoPreview.routeName),
                builder: (context) => PhotoPreview(
                  Utilities.getImage(item.itemImages[0]),
                ),
              ),
            );
          },
          child: Image(
            image: Utilities.getImage(item.itemImages[0]),
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    else if (item.itemImages == null || item.itemImages.isEmpty)
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.height * 0.2,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text('No Image'),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    else
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: item.itemImages.length,
          itemBuilder: (context, index) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: RouteSettings(name: PhotoPreview.routeName),
                        builder: (context) => PhotoPreview(
                          Utilities.getImage(item.itemImages[index]),
                        ),
                      ),
                    );
                  },
                  child:
                      Image(image: Utilities.getImage(item.itemImages[index]))),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
      );
  }
}