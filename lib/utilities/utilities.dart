import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:gx_file_picker/gx_file_picker.dart'; //this for android
import 'package:file_picker/file_picker.dart';  // this is for iOS
import '../models/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class ShowValidationMessage {
  static void showMessage(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(fontSize: 20),
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        elevation: 5,
      ),
    );
  }
}

class Utilities {
  static String appVersion;
  //Present a date picker to the user from where user can select date
  static Future<DateTime> datePicker(
    BuildContext context, {
    DateTime initialDate,
    DateTime endDate,
  }) async {
    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: initialDate != null ? initialDate : DateTime(2020),
      lastDate: endDate != null ? endDate : DateTime.now(),
    );

    return selectedDate;
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: false,
        enableDomStorage: true,
        enableJavaScript: true,
      );
    } else {
      print('Could not launch $url');
    }
  }

  static ImageProvider getFileImage(String file) {
    var ext = file.split('.').last;
    print('File extention : $ext');
    var icon = AppConstants.fileFormats[ext];
    print('File icon : $icon');
    return Image.asset(AppConstants.iconsFolder + 'fileIcons/$icon').image;
  }

  static ImageProvider getImage(
    String image, {
    double height,
    double width,
  }) {
    var imageExt = ['jpg', 'jpeg', 'png'];
    var ext = image.split('.').last;

    if (image.contains('asset'))
      return Image.asset(
        image,
        height: height,
        width: width,
      ).image;
    if (image.contains('AAAAA')) {
      Uint8List bytes = Base64Decoder().convert(image);
      return Image.memory(
        bytes,
        height: height,
        width: width,
      ).image;
    } else if (image.contains('https://')) {
      if (imageExt.contains(ext))
        return Image.network(image).image;
      else
        return getFileImage(image);
    } else
      return Image.file(
        File(image),
        height: height,
        width: width,
      ).image;
  }

  static String imageToBase64String(String imagePath) {
    if (imagePath.contains('AAAAAA')) return imagePath;
    var bytes = File(imagePath).readAsBytesSync();
    String img64 = base64Encode(bytes);
    //print(img64.substring(0, 100));
    return img64;
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permantly denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print('Location permissions are denied (actual value: $permission).');
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getCurrentCountry() async {
    Position position = await _determinePosition();
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    print(addresses.first.addressLine);
    print(addresses.first.countryName);
    return addresses.first.countryName;
  }

  static Future<void> showToastMessage(String message, {ToastGravity gravity}) async {
    await Fluttertoast.showToast(
      msg: message,
      gravity: gravity!=null?gravity:ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black54,
      fontSize: 20,
      textColor: Colors.white,
    );
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  static Widget showLabelAndText(String label, String text) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: label,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      TextSpan(
        text: text,
        style: TextStyle(color: Colors.black),
      ),
    ]));
  }

  static bool listContainsValueIgnoreCase(List<String> target, String key) {
    print('Checking value : $key');
    print('In the list : $target');
    bool flag = false;
    target.forEach((element) {
      if (element.toLowerCase() == key.toLowerCase()) {
        print('Found...');
        flag = true;
      }
    });
    return flag;
  }

  static Future<File> selectFile(BuildContext context) async {
    var fileFormat = AppConstants.fileFormats.keys.toList();
    fileFormat.addAll(
        ['jpg', 'jpeg', 'png']); //,'pdf','doc','docx','xls','xlsx','txt']);
    print("FileFormts $fileFormat");
    //Comment below line for iOS
    //||-----For Android--------------------------------------||
    // File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: fileFormat);
    //||-----For Android till here-----------------------------||
    
    //Uncomment below code for iOS
    // ||-----For IOS--------------------------------------||
    var results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: fileFormat,
    );
    File file = File(results.files.first.path);
    //||-----For IOS till here-----------------------------||

    if (file != null) {
      print(file.path);
      return file;
    } else {
      showToastMessage('User cancelled file picker');
    }
    return null;
  }
} //utilities
