import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              key: key,
              backgroundColor: Colors.black54,
              children: <Widget>[
                Center(
                  child: Column(children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please Wait....",
                      style: TextStyle(color: Colors.grey),
                    )
                  ]),
                )
              ],
            ),
          );
        });
  }

  static Future<void> showNonDismissibleLoading(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black45,
            children: [
              Center(
                child: Column(children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please Wait....",
                    style: TextStyle(color: Colors.grey),
                  )
                ]),
              )
            ],
          );
        });
  }

  static Future<void> showImage(
      BuildContext context, GlobalKey key, Widget image) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => true,
            child: SimpleDialog(
                key: key,
                backgroundColor: Colors.black54,
                children: <Widget>[
                  Center(
                    child: image,
                  )
                ]),
          );
        });
  }

  static Future<void> showZoomableImage(
      BuildContext context, GlobalKey key, ImageProvider image) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new WillPopScope(
            onWillPop: () async => true,
            child: SimpleDialog(
                key: key,
                backgroundColor: Colors.black54,
                children: <Widget>[
                  Center(
                    child: PhotoView(
                      imageProvider: image,
                    ),
                  )
                ]),
          );
        });
  }
}
