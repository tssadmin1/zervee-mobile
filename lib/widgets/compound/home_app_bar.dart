import '../../models/constants.dart';
import '../../widgets/simple/settings_button.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  static AppBar drawAppBar(BuildContext ctx) {
    return AppBar(
      iconTheme: IconThemeData(color: AppConstants.primaryColor),
      backgroundColor: Colors.white,
      // leading: IconButton(
      //     alignment: Alignment.centerRight,
      //     icon: ImageIcon(
      //       AssetImage(AppConstants.iconsFolder + 'menu3.png'),
      //       color: Colors.grey,
      //       size: 50,
      //     ),
      //     onPressed: null,
      //   ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'Filter by',
          //   style: TextStyle(
          //     color: Colors.grey,
          //     fontSize: 8,
          //   ),
          // ),
          // Text(
          //   'All Deals',
          //   style: TextStyle(
          //     color: AppConstants.primaryColor,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 30,
          //   ),
          // ),
          Container(
            width: MediaQuery.of(ctx).size.width * 0.6,
            child: TextField(
              onChanged: null,
              
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: EdgeInsets.all(10),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
      actions: [
        SettingsButton(),
      ],
    );
  }
}
