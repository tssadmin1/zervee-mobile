import '../../models/constants.dart';
import '../../widgets/simple/icon_button.dart';
import '../../screens/SignIn.dart';
import '../../screens/my_items.dart';
import '../../screens/homepage.dart';
import '../../screens/brands.dart';
import '../../models/auth_provider.dart';
import 'package:flutter/material.dart';

class ZerveeBottonNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function onAddPressed;
  final bool isAddItem;
  ZerveeBottonNavigationBar({this.selectedIndex = 5, this.onAddPressed, this.isAddItem = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.pink,
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 249, 112, 103),
              Color.fromARGB(255, 251, 102, 104),
              Color.fromARGB(255, 253, 82, 106),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 0.5, 1.0]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Home Icon
          Flexible(
            //flex: 1,
            child: IconButtonWithLabel(
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
              label: 'Home',
              onPressed: selectedIndex == 0
                  ? null
                  : () => Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName, (r) => false),
            ),
          ),

          //Brands Icon
          Flexible(
            child: IconButtonWithLabel(
              icon: Icon(
                Icons.local_offer_rounded,
                size: 30,
                color: Colors.white,
              ),
              label: 'Brands',
              onPressed: selectedIndex == 1
                  ? null
                  : () {
                      if (AuthProvider.isLoggedIn)
                        Navigator.of(context).pushNamed(Brands.routeName);
                      else {
                        //Navigator.of(context).pushNamed(Brands.routeName);
                        Navigator.of(context).pushNamed(
                          SignIn.routeName,
                        );
                      }
                    },
            ),
          ),

          //SizedBox(width: 20),

          Flexible(
            child: IconButtonWithLabel(
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                child: GestureDetector(
                  onTap: onAddPressed,
                  child: Icon(
                    Icons.add,
                    size: 35,
                  ),
                ),
              ),
              label: isAddItem? 'Item' : 'Brand',
              onPressed: onAddPressed,
            ),
          ),

          //Add Icon
          // Flexible(
          //   child: FittedBox(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         SizedBox(height: 3,),
          //         CircleAvatar(
          //           backgroundColor: Colors.white,
          //           child: GestureDetector(
          //             onTap: onAddPressed,
          //             child: Icon(
          //               Icons.add,
          //               size: 35,
          //             ),
          //           ),
          //         ),
          //         Text('Brand', style: TextStyle(color: Colors.white,),),
          //       ],
          //     ),
          //   ),
          // ),

          //SizedBox(width: 20),
          //List Icon
          Flexible(
            child: IconButtonWithLabel(
              icon: Icon(
                Icons.format_list_bulleted_rounded,
                color: Colors.white,
                size: 30,
              ),
              label: 'Items',
              onPressed: selectedIndex == 2
                  ? null
                  : () {
                      if (AuthProvider.isLoggedIn)
                        Navigator.of(context).pushNamed(MyItems.routeName);
                      else {
                        //Navigator.of(context).pushNamed(MyItems.routeName);
                        Navigator.of(context).pushNamed(SignIn.routeName);
                      }
                    },
            ),
          ),

          //Support request icon
          Flexible(
            child: IconButtonWithLabel(
              icon: ImageIcon(
                Image.asset(AppConstants.iconsFolder + 'Group_1613.png').image,
                size: 30,
                color: Colors.grey,
                //Colors.white,
              ),
              label: 'Support',
              onPressed: null,
              disabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
