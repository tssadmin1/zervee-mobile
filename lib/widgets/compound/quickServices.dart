import '../../models/constants.dart';
import 'package:flutter/material.dart';

class QuickServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: null,
                icon: Image.asset(
                  AppConstants.iconsFolder + 'quick_icon_1.jpg',
                  //color: AppConstants.primaryColor,
                ),
              ),
              Text(
                'Requests',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: null,
                icon: Image.asset(
                  AppConstants.iconsFolder + 'quick_icon_2.jpg',
                  //color: AppConstants.primaryColor,
                ),
              ),
              Text(
                'Chat',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: null,
                icon: Image.asset(
                  AppConstants.iconsFolder + 'quick_icon_3.jpg',
                  //color: AppConstants.primaryColor,
                ),
              ),
              Text(
                'Browser',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: null,
                icon: Image.asset(
                  AppConstants.iconsFolder + 'Group_1613.png',
                  color: AppConstants.primaryColor,
                ),
              ),
              Text(
                'Chat',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
