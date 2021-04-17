import 'package:flutter/material.dart';

class SideSecondaryButton extends StatelessWidget {
final String label;
final Function onPressed;
final double width;

SideSecondaryButton(this.label, {this.onPressed, this.width});

@override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Container(
                width: width,
                child: FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}