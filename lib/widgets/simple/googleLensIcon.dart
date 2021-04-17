import 'package:flutter/material.dart';

class GoogleLensIcon extends StatelessWidget {
  final Function onPressed;

  GoogleLensIcon({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
            // alignment: Alignment.bottomCenter,
            // margin: EdgeInsets.only(bottom: 25),
            // child: FloatingActionButton(
            //   heroTag: 'btn3',
            //   backgroundColor: Colors.white,
            //   onPressed: AuthProvider.isLoggedIn ? null : () => Navigator.pushReplacementNamed(context, SignIn.routeName),
            //   child: 
            //   ClipOval(
            //     child: Image.asset(AppConstants.iconsFolder + 'Google_Lens_logo.png'),
            //   ),
            // ),
          );
  }
  
}