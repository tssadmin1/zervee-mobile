//import '../../models/constants.dart';

import 'package:flutter/material.dart';

class AddBrandsButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  AddBrandsButton({this.label,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
            // alignment: Alignment.bottomCenter,
            // margin: EdgeInsets.only(bottom: 55),
            // child: FloatingActionButton(
            //   heroTag: 'btn4',
            //   onPressed: onPressed,
            //   child: Container(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           child: ImageIcon(
            //             AssetImage(AppConstants.iconsFolder + 'more.png'),
            //           ),
            //         ),
            //         Text(
            //           label,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 8,
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            // ),
          );
  }
  
}