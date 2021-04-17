import 'dart:io';

import 'package:flutter/material.dart';

class ExitWarningAlert extends StatelessWidget {
  final BuildContext _c;
  ExitWarningAlert(this._c);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit?'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                //Navigator.pop(_c, true);
                //Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
                //SystemNavigator.pop();
                exit(0);
              }
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(_c, false),
            ),
          ],
        );
  }
  
}