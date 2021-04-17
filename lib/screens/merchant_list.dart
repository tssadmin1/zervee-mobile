import '../providers/country_provider.dart';

import '../utilities/utilities.dart';
import '../screens/region.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_provider.dart';
import '../models/merchant_model.dart';
import '../models/constants.dart';
import '../providers/merchants_list_provider.dart';
import 'SignIn.dart';
import 'add_loyalty_card.dart';

class MerchantList extends StatefulWidget {
  static const routeName = '/merchant_list';

  @override
  _MerchantListState createState() => _MerchantListState();
}

class _MerchantListState extends State<MerchantList> {
  final _iconImgHeight = 30.0;
  final _iconImgWidth = 30.0;
  bool _init = true;
  String currentCountry = '';
  String searchText = '';
  bool _initFlag = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if(_init) {
      Provider.of<MerchantListProvider>(context, listen: false).fetchAndSetMerchants();
      setState(() {
        _init = false;
      });
    }
  }

  Future<void> _initMerchantList() async {
    if (!_initFlag) {
      debugPrint('Initializing merchants');
      currentCountry = await Utilities.getCurrentCountry();
      await Provider.of<MerchantListProvider>(context, listen: false)
          .initMerchants();
      _initFlag = true;
      debugPrint('merchants Initialization done');
    }
  }

  List<Merchant> _filteredMerchants(List<Merchant> m) {
    var countries = Provider.of<CountryProvider>(context).selectedCountries;
    print('Selected countries...$countries');
    if (countries.isEmpty) {
      countries.add(currentCountry);
    }
    var temp1 = Provider.of<MerchantListProvider>(context)
        .getMerchantsForSelectedCountries(countries);

    return temp1
        .where(
            (e) => e.brandName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  void _navigateToAddCard(BuildContext context, Merchant merchant) {
    if (AuthProvider.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(
        AddLoyaltyCard.routeName,
        arguments: merchant,
      );
    } else {
      Navigator.of(context).pushNamed(
        SignIn.routeName,
      );
    }
  }

  Future<void> _refreshMerchantListFromRemote(BuildContext context) async {
    await Provider.of<MerchantListProvider>(context, listen: false)
        .fetchAndSetMerchants();
  }

  List<Merchant> _top5Merchants(List<Merchant> m) {
    var temp = [..._filteredMerchants(m)];
    if (temp.length >= 5)
      return temp.getRange(0, 5).toList();
    else
      return temp.getRange(0, temp.length).toList();
  }

  List<Merchant> _sortedMerchants(List<Merchant> m) {
    var temp = [..._filteredMerchants(m)];
    temp.sort((m1, m2) {
      return m1.brandName.toLowerCase().compareTo(m2.brandName.toLowerCase());
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print('inside build method of Merchant list...');
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppConstants.primaryColor),
        title: Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Region.routeName);
            },
            child: Image.asset(AppConstants.iconsFolder + 'world.png'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshMerchantListFromRemote(context),
          child: FutureBuilder(
            future: _initMerchantList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('Waiting for response...');
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.error != null)
                return Center(
                  child: Text('Could not load list of Brands'),
                );
              return Consumer<MerchantListProvider>(
                builder: (context, merchantController, child) => Container(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (searchText.isEmpty)
                            Text(
                              'Frequenty Added',
                              style: TextStyle(
                                color: AppConstants.themeColorShade1,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          //Top 5 merchants
                          if (searchText.isEmpty)
                            //...merchantController.top5Merchants.map((merchant)
                            ..._top5Merchants(merchantController.merchants)
                                .map((merchant) {
                              return _merchantListButton(context, merchant);
                            }),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'All',
                              style: TextStyle(
                                color: AppConstants.themeColorShade1,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          //Other
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: TextButton(
                              // materialTapTargetSize:
                              //     MaterialTapTargetSize.shrinkWrap,
                              onPressed: () => _navigateToAddCard(
                                  context, merchantController.otherMerchant),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Card(
                                    shape: CircleBorder(),
                                    elevation: 5,
                                    child: Container(
                                      height: _iconImgHeight,
                                      width: _iconImgWidth,
                                      decoration: BoxDecoration(
                                        //color: Colors.red,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: Image.asset(
                                                    merchantController
                                                        .otherMerchant
                                                        .brandIconImage)
                                                .image),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    merchantController.otherMerchant.brandName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //All Merchants
                          ..._sortedMerchants(merchantController.merchants)
                              .map((merchant) {
                            return _merchantListButton(context, merchant);
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _merchantListButton(BuildContext context, Merchant merchant) {
    return Container(
      margin: EdgeInsets.only(top: 1),
      //padding: EdgeInsets.only(top: 5),
      child: TextButton(
        //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () => _navigateToAddCard(context, merchant),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: Utilities.getImage(merchant.brandIconImage)),
                ),
                height: _iconImgHeight,
                width: _iconImgWidth,
              ),
            ),
            SizedBox(width: 5),
            Text(
              merchant.brandName,
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyText1.color),
            ),
          ],
        ),
      ),
    );
  }
}