import '../../screens/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
          alignment: Alignment.centerRight,
          icon: Icon(Icons.account_circle, size: 30,),
          // ImageIcon(
          //   AssetImage(AppConstants.iconsFolder + 'gear.png'),
          //   color: AppConstants.primaryColor,
          //   size: 50,
          // ),
          onPressed: () {
            // if(AuthProvider.isLoggedIn) {
            //   AuthProvider.logout();
            //   Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
            // }
            Navigator.of(context).pushNamed(SettingsPage.routeName);
          },
        );
  }
  
}

