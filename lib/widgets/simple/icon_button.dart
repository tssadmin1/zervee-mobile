import 'package:flutter/material.dart';

class IconButtonWithLabel extends StatelessWidget {
  final Widget icon;
  final String label;
  final Function onPressed;
  final bool disabled;

  IconButtonWithLabel(
      {@required this.icon, @required this.label, this.onPressed, this.disabled=false});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              label,
              style: TextStyle(
                color: disabled?Colors.grey:Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
