import '../providers/merchants_list_provider.dart';
import '../widgets/compound/exit_warning_alert.dart';
import '../providers/item_provider.dart';
import '../providers/loyalty_card_provider.dart';
import '../providers/user_info_provider.dart';
import '../providers/advertisement_provider.dart';
import '../widgets/simple/global_search.dart';
import '../models/constants.dart';
import '../widgets/simple/settings_button.dart';
import 'merchant_list.dart';

import '../models/auth_provider.dart';
import '../widgets/compound/homePageContents.dart';
import '../widgets/compound/bottomNavigationBar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  bool init = true;

  void _navigateToMerchantList(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(MerchantList.routeName);
  }

  Future<void> _refreshAds(BuildContext context) async {
    await Provider.of<AdvertisementProvider>(context, listen: false)
        .fetchAndSetAds();
  }

  @override
  void initState() {
    super.initState();
    print('init Advertisements......');
    Provider.of<AdvertisementProvider>(context, listen: false).fetchAndSetAds();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(init)
    {Provider.of<MerchantListProvider>(context, listen: false)
        .fetchAndSetMerchants();
    if (AuthProvider.isLoggedIn) {
      Provider.of<LoyaltyCardProvider>(context, listen: false)
          .fetchAndSetLoyaltyCards();
      Provider.of<ItemProvider>(context, listen: false)
          .fetchAndSetItemsFromRemote(UserInfoProvider.userInfo.username);
    }
    init = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    print('HomePage build method...');
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => ExitWarningAlert(c),
      ),
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstants.primaryColor),
          backgroundColor: Colors.white,
          //centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageIcon(
              Image.asset(
                AppConstants.iconsFolder + 'Zervee_Logo_gradient.png',
              ).image,
            ),
          ),
          title: Container(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (AuthProvider.isLoggedIn) {
                  var cardController =
                      Provider.of<LoyaltyCardProvider>(context, listen: false);
                  var itemsController =
                      Provider.of<ItemProvider>(context, listen: false);
                  cardController.initLoyaltyCards();
                  itemsController.initItems(UserInfoProvider.userInfo.username);
                  showSearch(
                    context: context,
                    delegate: GlobalSearch(
                      cardController: cardController,
                      itemController: itemsController,
                    ),
                  );
                } else
                  showSearch(context: context, delegate: GlobalSearch());
              },
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search any...',
                  //labelText: labelText,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  //enabledBorder: InputBorder.none,
                  //errorBorder: InputBorder.none,
                  //disabledBorder: InputBorder.none,
                  enabled: false,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.grey,
                    iconSize: 30,
                    onPressed: () {
                      showSearch(context: context, delegate: GlobalSearch());
                    },
                  ),
                ),
              ),
            ),
          ),

          actions: [
            SettingsButton(),
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => _refreshAds(context),
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(new FocusNode()),
                    child: Column(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                              future: Provider.of<AdvertisementProvider>(
                                context,
                                listen: false,
                              ).initAdvertisements(),
                              builder: (context, dataSnapshot) {
                                if (dataSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  print(
                                      'Waiting for response in future builder...');
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (dataSnapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (dataSnapshot.error != null) {
                                    print(
                                        'Error occured while initialising ads');
                                    return Center(
                                      child: Text(
                                          'Something went wrong while loading advertisements'),
                                    );
                                  }
                                }
                                print('Successful...');
                                return Consumer<AdvertisementProvider>(
                                  builder: (ctx, value, child) =>
                                      HomePageContent(value.allAds),
                                );
                              }),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ZerveeBottonNavigationBar(
                            selectedIndex: 0,
                            onAddPressed: () =>
                                _navigateToMerchantList(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}