import 'dart:convert';

import '../webservices/openServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../models/constants.dart';
import '../models/merchant_model.dart';
//import 'package:get/state_manager.dart';

class MerchantListProvider with ChangeNotifier {
  //} extends GetxController {
  List<Merchant> _merchantsList = [];

  List<Merchant> get top5Merchants {
    if (_merchantsList.length >= 5) {
      return _merchantsList.getRange(0, 5).toList();
    }
    return [..._merchantsList];
  }

  List<Merchant> get merchants {
    return [..._merchantsList];
  }

  List<Merchant> get sortedMerchants {
    final sortedList = [..._merchantsList];
    sortedList.sort((m1, m2) {
      return m1.brandName.toLowerCase().compareTo(m2.brandName.toLowerCase());
    });
    return sortedList;
  }

  Merchant get otherMerchant {
    return new Merchant(
      id: '0',
      brandName: 'Other Card',
      brandIconImage: AppConstants.iconsFolder + 'OtherMerchant.png',
      brandCardImage: AppConstants.iconsFolder + 'OtherMerchant.png',
    );
  }

  Future<void> fetchAndSetMerchants() async {
    print('Calling API to fetch all merchants');
    Response res = await OpenService.getMerchants();
    try {
      if (res.statusCode == 200 && !res.body.contains('error')) {
        print('API Call successfull');
        List<dynamic> resBody = json.decode(res.body);
        print("Response parsed successfully");
        print('Fetched ${resBody.length} merchants');
        List<Merchant> temp = [];
        for (int i = 0; i < resBody.length; i++) {
          //print(resBody[i]);
          Merchant merchant = Merchant.fromJson(resBody[i]);
          print('parsed merchant...');
          print(merchant.id);
          merchant.brandCardImage = merchant.brandCardImage
              .replaceFirst('data:image/jpg;base64,', "")
              .replaceFirst('data:image/png;base64,', "")
              .replaceFirst('data:image/jpeg;base64,', "");
          merchant.brandIconImage = merchant.brandIconImage
              .replaceFirst('data:image/png;base64,', "")
              .replaceFirst('data:image/jpg;base64,', "")
              .replaceFirst('data:image/jpeg;base64,', "");

          print('Card image : ${merchant.brandCardImage.substring(1, 50)}');
          print('Icon image : ${merchant.brandIconImage.substring(1, 50)}');
          print('adding merchant...');
          print(merchant);
          temp.add(merchant);
        }
        //if (temp.isNotEmpty) {
          _merchantsList.clear();
          _merchantsList.addAll(temp);
          await _saveToSharedPrefs();
        //}
      } else
        print(
            'API call was not successfull. Something went wront while calling Get all merchants api');
    } catch (err) {
      print('!!!!!!!!!!Error!!!!!!!!!!!!!');
      print(err);
    }
    notifyListeners();
  }

  Future<void> _saveToSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Merchant.sharedPrefKey))
      prefs.remove(Merchant.sharedPrefKey);

    prefs.setStringList(
      Merchant.sharedPrefKey,
      _merchantsList.map((e) => merchantToJson(e)).toList(),
    );
  }

  Future<void> _fetchMerchantsFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Merchant.sharedPrefKey)) {
      List<Merchant> temp = [];
      prefs.getStringList(Merchant.sharedPrefKey).forEach((element) {
        temp.add(merchantFromJson(element));
      });
      if (temp.isNotEmpty) {
        _merchantsList.clear();
        _merchantsList.addAll(temp);
      }
    }
    notifyListeners();
  }

  Future<void> initMerchants() async {
    await _fetchMerchantsFromSharedPref();
    if (_merchantsList.isEmpty) {
      print(
          'No merchants found on local, therefore calling API to initialise merchant list...');
      await fetchAndSetMerchants();
    } else
      print('Merchants found on local');
  }

  List<Merchant> getMatchingMerchants(String brandName) {
    return _merchantsList
        .where(
          (element) =>
              element.brandName.toLowerCase().contains(brandName.toLowerCase()),
        )
        .toList();
  }

  List<Merchant> getMerchantsForSelectedCountries(List<String> countries) {
    return _merchantsList.where((e) {
      bool flag = false;
      for (int i = 0; i < countries.length; i++) {
        if (countries[i].toLowerCase() == e.location.toLowerCase()) {
          flag = true;
          break;
        } else if (countries[i].toLowerCase() == 'united states' &&
            e.location.toLowerCase() == 'usa') {
          flag = true;
          break;
        } else if (countries[i].toLowerCase() == 'united kingdom' &&
            e.location.toLowerCase() == 'uk') {
          flag = true;
          break;
        }
      }
      return flag;
    }).toList();
  }

  Merchant getMerchantById(String id) {
    var m = _merchantsList.where((element) => element.id == id).toList();
    if (m.isNotEmpty)
      return m.first;
    else
      return null;
  }
}