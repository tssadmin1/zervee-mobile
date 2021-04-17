import '../utilities/utilities.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/compound/dialogs.dart';

import '../providers/loyalty_card_provider.dart';

import '../providers/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/simple/settings_button.dart';
import '../providers/item_provider.dart';
import '../widgets/compound/my_item.dart';
import '../models/constants.dart';
import '../models/card_item.dart';
import '../widgets/compound/bottomNavigationBar.dart';
import 'package:flutter/material.dart';

import 'add_item.dart';

class MyItems extends StatefulWidget {
  static const routeName = '/MyItems';
  @override
  State<StatefulWidget> createState() {
    return _MyItemsState();
  }
}

class _MyItemsState extends State<MyItems> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<CardItem> myItems = [];
  bool loadingItems = false;
  bool loadedItems = false;
  bool _init = true;
  @override
  void dispose() {
    print('My Items dispose...');
    //myItems = [];
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      Provider.of<ItemProvider>(context, listen: false)
          .fetchAndSetItemsFromRemote(UserInfoProvider.userInfo.username);
      setState(() {
        _init = false;
      });
    }
    if (!AppConstants.myItemsLoaded) {
      AppConstants.myItemsLoaded = true;
      Utilities.showToastMessage("Swipe left to delete",
          gravity: ToastGravity.TOP);
    }
  }

  Future<void> _loadItemsAndBrands() async {
    print('Loading items....');
    var itemController = Provider.of<ItemProvider>(context, listen: false);
    if (itemController.items.isEmpty) {
      await itemController.initItems(UserInfoProvider.userInfo.username);
      await Provider.of<LoyaltyCardProvider>(context, listen: false)
          .initLoyaltyCards();
    }
  }

  Future<void> refreshScreen(BuildContext context) async {
    var itemController = Provider.of<ItemProvider>(context, listen: false);
    await itemController
        .fetchAndSetItemsFromRemote(UserInfoProvider.userInfo.username);
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.primaryColor),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Items',
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
                    future: _loadItemsAndBrands(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      if (snapshot.error != null)
                        return Center(
                          child: Text('Error! Could not load items'),
                        );
                      return Consumer<ItemProvider>(
                        builder: (context, itemController, _) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          color: Colors.white,
                          child: itemController.items.isEmpty
                              ? Center(
                                  child: Text('No items added yet'),
                                )
                              : ListView.builder(
                                  itemCount: itemController.items.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      key: Key(
                                          itemController.items[index].itemId),
                                      confirmDismiss: (direction) {
                                        return showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text('Warning!'),
                                                  content: Text(
                                                      'Do you really want to delete'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          await _deleteItem(
                                                              context,
                                                              itemController,
                                                              index);
                                                          return true;
                                                        },
                                                        child: Text('Yes')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          return false;
                                                        },
                                                        child: Text('No')),
                                                  ],
                                                ));
                                      },
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.delete,
                                          color: AppConstants.primaryColor,
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: MyItem(
                                          itemController.items[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      );
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ZerveeBottonNavigationBar(
                selectedIndex: 2,
                onAddPressed: () {
                  Navigator.of(context).pushNamed(AddItem.routeName);
                },
                isAddItem: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _deleteItem(
      BuildContext context, ItemProvider itemController, int index) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    print('Dismissed');
    String msg = await Provider.of<ItemProvider>(context, listen: false)
        .deleteItem(itemController.items[index].itemId);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(msg),
    // ));
  }
}
