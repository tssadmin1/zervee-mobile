import 'package:firebase_core/firebase_core.dart';

import './screens/resetPassword.dart';
import './providers/country_provider.dart';
import './providers/merchants_list_provider.dart';
import './providers/item_provider.dart';
import './providers/loyalty_card_provider.dart';
import './providers/user_info_provider.dart';
import './providers/advertisement_provider.dart';
import './screens/region.dart';
import './screens/showWebView.dart';
import './screens/item_details.dart';
import './screens/settings_page.dart';
import './screens/my_items.dart';
import './screens/add_item.dart';
import './screens/add_loyalty_card.dart';
import './screens/brand_details.dart';
import './screens/brands.dart';
import './screens/merchant_list.dart';
import './screens/SignUp.dart';
import './screens/forgotPassword.dart';
import './screens/homepage.dart';
import './screens/verification.dart';
import './screens/SignIn.dart';

import './models/constants.dart';
import './models/auth_provider.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Firebase.initializeApp();
  AuthProvider.tryAutoLogin().then((value) async {
    if (value) {
      print("User is logged in");
      await UserInfoProvider().fetchAndSetUserInfo();
    } else {
      print("user is not logged in");
      AuthProvider.logout();
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdvertisementProvider>(
          create: (_) => AdvertisementProvider(),
        ),
        ChangeNotifierProvider<LoyaltyCardProvider>(
          create: (_) => LoyaltyCardProvider(),
        ),
        ChangeNotifierProvider<ItemProvider>(
          create: (_) => ItemProvider(),
        ),
        ChangeNotifierProvider<MerchantListProvider>(
          create: (_) => MerchantListProvider(),
        ),
        ChangeNotifierProvider<CountryProvider>(
          create: (_) => CountryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zervee',
        theme: ThemeData( 
          primarySwatch: AppConstants.primaryMaterialColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'SFPro',
        ),
        //home: SplashScreen(),
        routes: {
          '/': (context) => HomePage(),
          HomePage.routeName: (context) => HomePage(),
          SignIn.routeName: (context) => SignIn(),
          SignUp.routeName: (context) => SignUp(),
          ForgotPassword.routeName: (context) => ForgotPassword(),
          Verification.routeName: (context) => Verification(),
          MerchantList.routeName: (context) => MerchantList(),
          AddLoyaltyCard.routeName: (context) => AddLoyaltyCard(),
          Brands.routeName: (context) => Brands(),
          BrandDetails.routeName: (context) => BrandDetails(),
          AddItem.routeName: (context) => AddItem(),
          MyItems.routeName: (context) => MyItems(),
          SettingsPage.routeName: (context) => SettingsPage(),
          ItemDetails.routeName: (context) => ItemDetails(),
          Region.routeName: (context) => Region(),
          ShowWebView.routeName: (context) => ShowWebView(),
          ResetPassword.routeName: (context) => ResetPassword(),
        },
      ),
    );
  }
}
