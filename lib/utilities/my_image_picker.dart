import 'dart:io';

import '../utilities/utilities.dart';
import '../webservices/CustomerServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker {
  BuildContext context;
  PickedFile pickedImage;
  File file;
  MyImagePicker(this.context);

  _openGallery(BuildContext context) async {
    pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Make a choice'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text('Open Camera'),
                      onTap: () {
                        _openCamera(context);
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  Future<PickedFile> get pickImage async {
    return _showChoiceDialog(context).then((value) {
      return pickedImage;
    });
  }

  Future<String> pickAndUploadImage() async {
    await _showChoiceDialog(context);
    var url = await CustomerService.uploadFile(pickedImage.path);
    if (!url.contains('https://'))
      Utilities.showToastMessage('File could not be uploaded');
    return url;
  }

  Future<String> pickAndUploadFile() async {
    var file = await Utilities.selectFile(context);
    var ext = file.path.split('.').last;
    print('Selected file extension : $ext');
    if (file != null) {
      var url = await CustomerService.uploadFile(file.path);
      if (url.contains('https://'))
        return url;
      else
        Utilities.showToastMessage('File upload failed');
    }
    return null;
  }

  Future<void> _pickFile() async {
    var temp = await Utilities.selectFile(context);
    Navigator.of(context).pop();
    pickedImage = PickedFile(temp.path);
  }

  Future<String> pickAndUploadImageOrFile() async {
    await _show3ChoicesDialog(context);
    if (pickedImage == null) return null;
    var url = await CustomerService.uploadFile(pickedImage.path);
    if (!url.contains('https://'))
      Utilities.showToastMessage('File could not be uploaded');
    return url;
  }

  Future<String> _show3ChoicesDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Make a choice'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text('Open Camera'),
                      onTap: () {
                        _openCamera(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text('Select File'),
                      onTap: () {
                        _pickFile();
                      },
                    ),
                  ],
                ),
              ));
        });
  }
}
