import 'package:flutter/material.dart';

class SideMainButton extends StatelessWidget {
  final String label;
  final double width;
  final Function onPressed;
  SideMainButton(this.label, {this.width, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return 
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), 
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              width: width,
              decoration: (
                BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 249, 112, 103),
                      //Color.fromARGB(255, 251, 102, 104),
                      Color.fromARGB(255, 253, 82, 106),
                    ],
                    stops: [0.3,0.5],
                  )
                )
              ),
              child: FlatButton(
                onPressed: onPressed,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    
  }
  
}