import '../providers/country_provider.dart';
import '../providers/item_provider.dart';
import '../providers/loyalty_card_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../providers/user_info_provider.dart';

import '../models/auth_provider.dart';
import '../models/constants.dart';
import 'package:flutter/material.dart';

import 'SignIn.dart';
import 'homepage.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '';
  bool init = true;
  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    print(packageInfo.appName);
    print(packageInfo.packageName);
    print(packageInfo.version);
    print(packageInfo.buildNumber);

    //return packageInfo.buildNumber;
  }

  @override
  void didChangeDependencies() {
    if (init)
      PackageInfo.fromPlatform().then((packageInfo) {
        setState(() {
          init = false;
          _appVersion = packageInfo.version;
          print(packageInfo.appName);
          print(packageInfo.packageName);
          print(packageInfo.version);
          print(packageInfo.buildNumber);
        });
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstants.primaryColor),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              child: Card(
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    //color: Colors.pink,
                  ),
                  //alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            AuthProvider.isLoggedIn
                                ? ListTile(
                                    leading: Icon(
                                      Icons.account_circle,
                                      size: 40,
                                      color: AppConstants.primaryMaterialColor,
                                    ),
                                    title: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 20,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () => showDialog<bool>(
                                      context: context,
                                      builder: (c) =>
                                          //LogoutConfirmation(ctx: context),
                                          AlertDialog(
                                        title: Text('Logout Confirmation'),
                                        content: Text(
                                            'Do you really want to logout?'),
                                        actions: [
                                          TextButton(
                                              child: Text('Yes'),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                                Provider.of<LoyaltyCardProvider>(
                                                        context,
                                                        listen: false)
                                                    .clearCards();
                                                Provider.of<ItemProvider>(
                                                        context,
                                                        listen: false)
                                                    .clearItems();
                                                AuthProvider.logout();
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        HomePage.routeName,
                                                        (route) => false);
                                              }),
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListTile(
                                    leading: Icon(
                                      Icons.account_circle,
                                      size: 40,
                                      color: AppConstants.primaryMaterialColor,
                                    ),
                                    title: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .pushNamed(SignIn.routeName);
                                    },
                                  ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //App version
                          FittedBox(
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'version ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      )),
                                  TextSpan(
                                    text: _appVersion,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.accents.first,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          //Logged in as
                          AuthProvider.isLoggedIn
                              ? Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Logged in as  ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                          )),
                                      TextSpan(
                                        text: UserInfoProvider.userInfo.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.accents.first,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ]),
                                  ),
                                )
                              : SizedBox(
                                  width: 10,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class LogoutConfirmation extends StatelessWidget {
  final BuildContext ctx;

  const LogoutConfirmation({
    this.ctx,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout Confirmation'),
      content: Text('Do you really want to logout?'),
      actions: [
        TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.pop(context, false);
              Provider.of<LoyaltyCardProvider>(context).dispose();
              Provider.of<ItemProvider>(context).dispose();
              Provider.of<CountryProvider>(context).dispose();
              AuthProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (route) => false);
            }),
        TextButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}