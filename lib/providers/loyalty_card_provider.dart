import '../webservices/LoyaltyCardServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_info_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/loyalty_card_model.dart';

class LoyaltyCardProvider with ChangeNotifier {
  List<LoyaltyCard> _loyaltyCards = [];

  List<LoyaltyCard> get loyaltyCards {
    return [..._loyaltyCards];
  }

  bool cardExists(LoyaltyCard card) {
    _loyaltyCards.forEach((element) {
      if (element.cardId == card.cardId) return true;
    });
    return false;
  }

  List<String> get allBrandsForAddedCards {
    if (_loyaltyCards.isNotEmpty) {
      var temp = _loyaltyCards.map((e) => e.storeName).toSet().toList();
      print(temp);
      return temp;
    }
    return [];
  }

  String getCardIdForStoreName(String storeName) {
    var cards =
        loyaltyCards.where((card) => card.storeName == storeName).toList();
    if (cards.isEmpty) return null;
    return cards.first.cardId;
  }

  String getBrandNameForCardId(String cardId) {
    return loyaltyCards
        .where((element) => element.cardId == cardId)
        .first
        .storeName;
  }

  Future<void> fetchAndSetLoyaltyCards() async {
    var userName = UserInfoProvider.userInfo.username;
    print('Fetching all the loyalty Cards for the user $userName');
    var res = await LoyaltyCardService.getCards(userName);
    if (res != null &&
        res.statusCode == 200 &&
        !res.body.toString().contains('error')) {
      print('Got correct response for get all cards API...');
      List<dynamic> resBody = json.decode(res.body);
      print("Response parsed successfully");
      print('Fetched ${resBody.length} Ads');
      List<LoyaltyCard> cards = [];
      for (int i = 0; i < resBody.length; i++) {
        print('Parsing json to Loyalty Card object...');
        var card = LoyaltyCard.fromJson(resBody[i]);
        print('successfully parsed json to Loyalty Card object...');
        cards.add(card);
      }
      _loyaltyCards.clear();
      _loyaltyCards.addAll(cards);
      await _saveLoyaltyCardsOnLocal();
    } else {
      print('Could not fetch loyalty cards from remote');
      print('${res.statusCode} : ${res.body}');
    }
    notifyListeners();
  }

  Future<String> _saveLoyaltyCardsOnRemote(LoyaltyCard card) async {
    String msg;
    print('Starting to add new Loyalty Card');
    try {
      var res;
      if (card.cardId == null)
        res = await LoyaltyCardService.addCard(card);
      else
        res = await LoyaltyCardService.editCard(card);

      if (res.statusCode == 200 && !res.body.toString().contains('error')) {
        print('New Loyalty card has been added successfully on server');
        LoyaltyCard newCard = loyaltyCardFromJson(res.body);
        if (card.cardId != null)
          _loyaltyCards.removeWhere((element) => element.cardId == card.cardId);
        _loyaltyCards.add(newCard);
        msg = 'Card Added successfully';

        notifyListeners();
      } else if (res.statusCode == 200 &&
          res.body.toString().contains('already exist')) {
        msg = 'Loyalty Card already exist';
      }
    } on Exception catch (e) {
      print('$e');
    }
    return msg;
  }

  Future<String> saveLoyaltyCard(LoyaltyCard card) async {
    String flag;
    flag = await _saveLoyaltyCardsOnRemote(card);
    if (!flag.contains('already exist')) {
      await _saveLoyaltyCardsOnLocal();
      return flag;
    }
    return flag;
  }

  Future<bool> _saveLoyaltyCardsOnLocal() async {
    print('Saving loyalty cards on local storage...');
    var prefs = await SharedPreferences.getInstance();
    bool flag = false;
    try {
      if (prefs.containsKey(LoyaltyCard.prefsKey))
        prefs.remove(LoyaltyCard.prefsKey);
      flag = await prefs.setStringList(
        LoyaltyCard.prefsKey,
        _loyaltyCards.map((e) => loyaltyCardToJson(e)).toList(),
      );
    } on Exception catch (e) {
      print('$e');
    }
    if (flag)
      print('Loyalty Cards saved on local successfully');
    else
      print('Something went wrong while saving loyaltyCards on local storage');

    return flag;
  }

  Future<bool> initLoyaltyCards() async {
    print('Initializing loyalty Cards');
    var prefs = await SharedPreferences.getInstance();
    bool flag = false;
    try {
      if (prefs.containsKey(LoyaltyCard.prefsKey)) {
        print('Cards found on local storage...');
        List<String> res = prefs.getStringList(LoyaltyCard.prefsKey);
        List<LoyaltyCard> temp = [];
        res.forEach((card) {
          temp.add(loyaltyCardFromJson(card));
        });
        _loyaltyCards.clear();
        _loyaltyCards.addAll(temp);
        if (_loyaltyCards.isNotEmpty) {
          print('Loyalty Cards initialized successfully');
          flag = true;
        }
      }
      if (_loyaltyCards.isEmpty) {
        print('No cards on local storage, therefore fetching from Remote');
        await fetchAndSetLoyaltyCards();
        flag = true;
      }
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
    return flag;
  }

  void clearCards() {
    _loyaltyCards = [];
    SharedPreferences.getInstance().then((value) {
      if (value.containsKey(LoyaltyCard.prefsKey))
        value.remove(LoyaltyCard.prefsKey);
    });
  }

  Future<String> deleteCard(String cardId) async {
    print('deleting card');
    var res = await LoyaltyCardService.deleteCard(cardId);
    if (res.statusCode == 200 && !res.body.contains('error')) {
      _loyaltyCards.removeWhere((element) => element.cardId == cardId);
      _saveLoyaltyCardsOnLocal();
      notifyListeners();
      return 'Deleted successfully';
    }
    return null;
  }

  List<LoyaltyCard> search(String search) {
    return _loyaltyCards
        .where((card) =>
            (card.brandId != null &&
                card.brandId.toLowerCase().contains(search.toLowerCase())) ||
            (card.cardId != null &&
                card.cardId.toLowerCase().contains(search.toLowerCase())) ||
            (card.cardName != null &&
                card.cardName.toLowerCase().contains(search.toLowerCase())) ||
            (card.cardNumber != null &&
                card.cardNumber.toLowerCase().contains(search.toLowerCase())))
        .toList();
  }
}

/**
 * var brands = [
    Brand('2', 'starbucks', AppConstants.iconsFolder + 'starbucks_card.png'),
    Brand('3', 'spotlight', AppConstants.iconsFolder + 'spotlight_card.png'),
    Brand('4', 'fraserworld', AppConstants.iconsFolder + 'fraserworld_card.png'),
    Brand('1', 'watsons', AppConstants.iconsFolder + 'watsons_card.png'),
  ];
 */
