import '../webservices/openServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/advertisement_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdvertisementProvider with ChangeNotifier {
  List<Advertisement> _allAdvertisements = [];

  List<Advertisement> get allAds {
    var temp = _allAdvertisements.where((element) => DateTime.parse(element.advertisementEndDate).isAfter(DateTime.now())).toList();
    return [...temp];
  }

  Future<void> fetchAndSetAds() async {
    print('Calling Get all Ads API');
    http.Response res = await OpenService.getAdvertisements();
    print('Get All Ads api call finished');
    if (res != null && res.statusCode == 200 && !res.body.contains('error')) {
      List<dynamic> resBody = json.decode(res.body);
      print("Response parsed successfully");
      print('Fetched ${resBody.length} Ads');
      List<Advertisement> temp = [];
      for (int i = 0; i < resBody.length; i++) {
        Advertisement ad = Advertisement.fromJson(resBody[i]);
        if (ad.url == null || ad.url.isEmpty) ad.url = 'http://www.zervee.com';
        temp.add(ad);
      }
      _allAdvertisements.clear();
      _allAdvertisements.addAll(temp);
      notifyListeners();

      saveAllAdsToSharedPrefs();
    }
  }

  Future<void> _fetchAllAdsFromSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.containsKey(Advertisement.sharedPrefsKey)) {
        print('Fetching ads from shared prefs');
        var ads = prefs.getStringList(Advertisement.sharedPrefsKey);
        print('Fetched ads from shared prefs successfully');
        //List<dynamic> ads = json.decode(content);
        print('Number of ads fetched from shared prefs ${ads.length}');
        ads.forEach((element) {
          var ad = advertisementFromJson(element);
          if (!_allAdvertisements.contains(ad)) _allAdvertisements.add(ad);
        });
      }
    } catch (err) {
      print('Error!!!!!!!');
      print(err);
    }
  }

  Future<void> saveAllAdsToSharedPrefs() async {
    print('saving ads to shared preferences...');
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Advertisement.sharedPrefsKey))
      prefs.remove(Advertisement.sharedPrefsKey);

    print('Saving all ads to Shared Preferences');
    try {
      prefs
          .setStringList(
        Advertisement.sharedPrefsKey,
        _allAdvertisements.map((e) => advertisementToJson(e)).toList(),
      )
          .then((value) {
        if (value)
          print('Successfully saved All Advertisements to SharedPreferences');
        else
          print(
              'Error!!! Something went wrong while saving ads to SharedPreferences');
      });
    } catch (err) {
      print('$err');
    }
  }

  Future<void> initAdvertisements() async {
    await _fetchAllAdsFromSharedPrefs();
    if(_allAdvertisements.isEmpty)
      await fetchAndSetAds();
    else
      notifyListeners();
  }

  List<Advertisement> get horizontalAds {
    var temp = _allAdvertisements.where((ad) => ad.displayType.toLowerCase()=='horizontal').toList();
    return [...temp];
  }

  List<Advertisement> get verticalAds {
    var temp = _allAdvertisements.where((ad) => ad.displayType.toLowerCase()=='vertical').toList();
    return [...temp];
  }

}
