import '../../models/constants.dart';
import 'package:flutter/material.dart';

class LogoWithTextHeader extends StatelessWidget { 
  final String text;

  LogoWithTextHeader(this.text);

  @override
  Widget build(BuildContext context) {
    
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                AssetImage(AppConstants.iconsFolder+'Zervee_Logo_gradient.png'),
                color: AppConstants.primaryColor,
                size: 50,
              ),
              Text(
                text, 
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  ),
              ),
            ],
          );
  }
  
}