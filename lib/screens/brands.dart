import 'package:fluttertoast/fluttertoast.dart';

import '../providers/item_provider.dart';

import '../utilities/utilities.dart';
import '../widgets/compound/dialogs.dart';
import '../widgets/simple/settings_button.dart';
import 'package:provider/provider.dart';
import 'brand_details.dart';

import '../providers/loyalty_card_provider.dart';
import '../models/constants.dart';
import '../widgets/compound/bottomNavigationBar.dart';
import 'package:flutter/material.dart';

import 'merchant_list.dart';

class Brands extends StatefulWidget {
  static const String routeName = '/brand';

  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool _init = true;
  void _navigateToMerchantList(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(MerchantList.routeName);
  }

  Future _deleteCard(
      BuildContext context, LoyaltyCardProvider cards, int index) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    print('Dismissed');
    String msg = await Provider.of<LoyaltyCardProvider>(context, listen: false)
        .deleteCard(cards.loyaltyCards[index].cardId);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  Future<void> refreshScreen(BuildContext context) async {
    print('Refreshing screen...');
    await Provider.of<LoyaltyCardProvider>(context, listen: false)
        .fetchAndSetLoyaltyCards();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      Provider.of<LoyaltyCardProvider>(context, listen: false)
          .fetchAndSetLoyaltyCards();
      setState(() {
        _init = false;
      });
    }
    if (!AppConstants.brandsLoaded) {
      AppConstants.brandsLoaded = true;
      Utilities.showToastMessage("Swipe left to delete",
          gravity: ToastGravity.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Inside Brands Build Method...');
    var cardItemProvider = Provider.of<ItemProvider>(context, listen: false);
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.primaryColor),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BRANDS',
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
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => refreshScreen(context),
                child: FutureBuilder(
                  future:
                      Provider.of<LoyaltyCardProvider>(context, listen: false)
                          .initLoyaltyCards(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('Loading...brands...');
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.error != null)
                      return Center(
                        child: Text(
                            'Something went wrong while loading User\'s Cards'),
                      );
                    return Consumer<LoyaltyCardProvider>(
                      builder: (context, brands, child) => brands
                              .loyaltyCards.isEmpty
                          ? Center(child: Text('No brands added yet'))
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              itemCount: brands.loyaltyCards.length,
                              itemBuilder: (context, index) {
                                var card = brands.loyaltyCards[index];
                                return Dismissible(
                                  confirmDismiss: (direction) {
                                    return showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          var cardId =
                                              brands.loyaltyCards[index].cardId;
                                          if (cardItemProvider
                                              .getItemsForCard(cardId)
                                              .isNotEmpty)
                                            return AlertDialog(
                                              title: Text('Card has Items'),
                                              content: Text(
                                                  'Please delete all items under the card before deleting it'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      return false;
                                                    },
                                                    child: Text('OK')),
                                              ],
                                            );
                                          return AlertDialog(
                                            title: Text('Warning!'),
                                            content: Text(
                                                'Do you really want to delete'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await _deleteCard(
                                                        context, brands, index);
                                                    return true;
                                                  },
                                                  child: Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    return false;
                                                  },
                                                  child: Text('No')),
                                            ],
                                          );
                                        });
                                  },
                                  key: Key(card.cardId),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    //margin: EdgeInsets.only(right:20),
                                    child: Icon(
                                      Icons.delete,
                                      color: AppConstants.primaryColor,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          BrandDetails.routeName,
                                          arguments: card);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 2,
                                      child: Container(
                                        //color: Colors.white,
                                        padding: EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        alignment: Alignment.bottomCenter,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        //Create Card image
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: Utilities.getImage(
                                                card.cardImage),
                                          ),
                                        ),
                                        //Print Card Number on the card image
                                        child: (card.cardNumber != null &&
                                                card.cardNumber.isNotEmpty)
                                            ? FittedBox(
                                                child: Text(
                                                  card.cardNumber,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    backgroundColor:
                                                        Colors.black12,
                                                    letterSpacing: 5,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ZerveeBottonNavigationBar(
                selectedIndex: 1,
                onAddPressed: () => _navigateToMerchantList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
