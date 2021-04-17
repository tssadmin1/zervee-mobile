import '../providers/merchants_list_provider.dart';
import '../screens/photo_preview.dart';

import '../utilities/utilities.dart';

import '../providers/user_info_provider.dart';

import '../providers/item_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/simple/settings_button.dart';

import 'add_item.dart';
import '../widgets/compound/bottomNavigationBar.dart';
import '../widgets/compound/my_card_item.dart';
import '../models/loyalty_card_model.dart';
import '../models/constants.dart';
import 'package:flutter/material.dart';

class BrandDetails extends StatefulWidget {
  static const routeName = '/brandDetails';

  @override
  State<StatefulWidget> createState() {
    return _BrandDetailsState();
  }
}

class _BrandDetailsState extends State<BrandDetails> {
  bool loadingItems = false;

  void showCommingSoonMessage() {
    Utilities.showToastMessage('Coming soon...');
  }

  @override
  void dispose() {
    print('Brand Details dispose...');
    super.dispose();
  }

  @override
  void initState() {
    var itemProvider = Provider.of<ItemProvider>(context, listen: false);
    if (itemProvider.items.isEmpty) {
      setState(() {
        loadingItems = true;
      });
      itemProvider.initItems(UserInfoProvider.userInfo.username).then((value) {
        setState(() {
          loadingItems = false;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    LoyaltyCard _card = ModalRoute.of(context).settings.arguments;
    var merchant = Provider.of<MerchantListProvider>(context, listen: false)
        .getMerchantById(_card.brandId);
    print('Card Id : ${_card.cardId}');
    // var items =
    //     Provider.of<ItemController>(context).getItemsForCard(_card.cardId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.primaryColor),
        backgroundColor: Colors.white,
        title: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (merchant != null && merchant.brandIconImage.isNotEmpty)
                  ? FittedBox(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppConstants.primaryColor,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: Utilities.getImage(merchant.brandIconImage),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              FittedBox(
                child: Text(
                  _card.storeName,
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          SettingsButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  //Card Image widget
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            settings:
                                RouteSettings(name: PhotoPreview.routeName),
                            builder: (context) => PhotoPreview(
                              Utilities.getImage(_card.cardImage),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: Utilities.getImage(_card.cardImage),
                          ),
                        ),
                        //Print Card Number on the card image
                        child: (_card.cardNumber != null &&
                                _card.cardNumber.isNotEmpty)
                            ? FittedBox(
                                child: Text(
                                  _card.cardNumber,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.black12,
                                    letterSpacing: 5,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ),
                  //Action Buttons for the user
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyCard(
                            iconPath: AppConstants.iconsFolder + 'more.png',
                            label: Text(
                              'Create Request',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: showCommingSoonMessage,
                          ),
                          MyCard(
                            iconPath: AppConstants.iconsFolder + 'month.png',
                            label: Text(
                              'Appointment',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: showCommingSoonMessage,
                          ),
                          MyCard(
                            iconPath: AppConstants.iconsFolder + 'callback.png',
                            label: Text(
                              'Callback Request',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: showCommingSoonMessage,
                          ),
                          MyCard(
                            iconPath: AppConstants.iconsFolder + 'progress.png',
                            label: Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: showCommingSoonMessage,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //List of items under the card
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 3,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 20,
                            ),
                            child: Text(
                              'My Items',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          loadingItems
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Consumer<ItemProvider>(
                                  builder: (context, value, child) => Expanded(
                                    child: ListView(
                                      padding: EdgeInsets.only(bottom: 30),
                                      children: [
                                        if (value
                                            .getItemsForCard(_card.cardId)
                                            .isNotEmpty)
                                          ...value
                                              .getItemsForCard(_card.cardId)
                                              .map((myItem) {
                                            return MyCardItem(
                                              myItem: myItem,
                                            );
                                          }).toList()
                                        else
                                          Align(
                                            child: Text('No Items Added'),
                                            alignment: Alignment.center,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ZerveeBottonNavigationBar(
                onAddPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddItem.routeName, arguments: _card.cardId);
                },
                isAddItem: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String iconPath;
  final Widget label;
  final Function onPressed;

  MyCard({this.iconPath, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Card(
        elevation: 3,
        child: TextButton(
          //disabledColor: Colors.grey,
          onPressed: onPressed,
          //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageIcon(
                  Image.asset(
                    iconPath,
                  ).image,
                  //AssetImage(iconPath,),
                  color: Colors.grey[400]
                  //AppConstants.primaryColor,
                  ),
              label,
            ],
          ),
        ),
      ),
    );
  }
}