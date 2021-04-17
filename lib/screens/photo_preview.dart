import '../models/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreview extends StatelessWidget {
  static const String routeName = '/photoPreview';
  final ImageProvider image;
  PhotoPreview(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstants.primaryColor),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
              child: Container(
          child: PhotoView(imageProvider: image),
        ),
      ),
    );
  }
}
