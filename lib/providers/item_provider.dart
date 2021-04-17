import '../webservices/CardItemServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import '../models/card_item.dart';
import 'dart:convert';

class ItemProvider with ChangeNotifier {
  List<CardItem> _items = [];

  List<CardItem> get items {
    return [..._items];
  }

  void clearItems() {
    _items.clear();
  }

  void _removeItem(String itemId) {
    _items.removeWhere((element) => element.itemId == itemId);
  }

  List<CardItem> getItemsWhere(String cardId) {
    return _items.where((item) => item.cardId == cardId).toList();
  }

  CardItem getItemById(String itemId) {
    return _items.where((element) => element.itemId==itemId).toList().first;
  }

  Future<CardItem> addNewItemOnRemote(CardItem item) async {
    bool flag = false;
    var res = await CardItemService.addCardItem(item);
    if (res != null && res.statusCode == 200 && !res.body.contains('error')) {
      print('New items has been added in the card successfully');
      print('response content as follows....');

      item = cardItemFromJson(res.body);
      print(item.itemId);
      _items.add(item);
      flag = true;
    } else {
      print('Could not add new item in card');
      print('${res.statusCode} : ${res.body}');
    }
    await _saveItemsOnLocal();
    notifyListeners();
    if (flag) return item;
    return null;
  }

  Future<CardItem> editItemOnRemote(CardItem item) async {
    bool flag = false;
    var res = await CardItemService.editCardItem(item);
    if (res != null && res.statusCode == 200 && !res.body.contains('error')) {
      print('New items has been edited successfully');
      _removeItem(item.itemId);
      _items.add(item);
      flag = true;
    } else {
      print('Could not Edit item');
      print('${res.statusCode} : ${res.body}');
    }
    await _saveItemsOnLocal();
    notifyListeners();
    return flag?item:null;
  }

  List<CardItem> getItemsForCard(String cardId) {
    var temp = _items.where((item) => item.cardId == cardId).toList();
    print('Found ${temp.length} items for Card $cardId');
    if (temp != null)
      return temp;
    else
      return [];
  }

  Future<void> _saveItemsOnLocal() async {
    print('Saving items on local...');
    try {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(CardItem.cardItemPrefsKey))
        prefs.remove(CardItem.cardItemPrefsKey);

      prefs.setStringList(
        CardItem.cardItemPrefsKey,
        _items.map((e) => cardItemToJson(e)).toList(),
      );
      print('Items saved on local successfully');
    } on Exception catch (e) {
      print('Error: Something went wrong while saving items on local');
      print(e);
    }
  }

  Future<void> fetchItemsFromLocal() async {
    print('Fetching items from local storage');
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(CardItem.cardItemPrefsKey)) {
      print('Card items found on local storage');
      List<String> items = prefs.getStringList(CardItem.cardItemPrefsKey);

      items.forEach((element) {
        CardItem item = cardItemFromJson(element);
        if (!_items.contains(item)) _items.add(item);
      });
      print('Items fetched from local successfully');
    } else {
      print('Could not find Card Items on Local Storage');
    }
    notifyListeners();
  }

  Future<void> fetchAndSetItemsFromRemote(String userName) async {
    print('fetching items from remote');
    var res = await CardItemService.getCardItems(userName);
    if (res != null && res.statusCode == 200 && !res.body.contains('error')) {
      print('Items fetched from remote');
      print('Parsing the items');
      List<dynamic> fetchedList = json.decode(res.body);
      print('Fetch ${fetchedList.length} items');
      if (fetchedList.isEmpty) {
        _items.clear();
        _saveItemsOnLocal();
      } else {
        List<CardItem> temp = [];
        fetchedList.forEach((element) {
          CardItem item = CardItem.fromJson(element);
          temp.add(item);
        });
        _items.clear();
        _items.addAll(temp);
        print('Added fetched items to the list');
        _saveItemsOnLocal();
      }
    } else {
      print('API call failed...');
      print('${res.statusCode} ::: ${res.body}');
    }
    notifyListeners();
  }

  Future<void> initItems(String userName) async {
    print('initializing the items for the user $userName');
    await fetchItemsFromLocal();
    if (_items.isEmpty) {
      print('Could not find any item on local, fetching from remote');
      await fetchAndSetItemsFromRemote(userName);
      if (_items.isEmpty) print('There are no items for the user $userName');
    }
    notifyListeners();
  }

  Future<String> deleteItem(String itemId) async {
    var res = await CardItemService.deleteCardItem(itemId);
    if (res.statusCode == 200 && !res.body.contains('error')) {
      print('Item Deleted successfully');
      //String itemName = cardItemFromJson(res.body).itemName;
      _items.removeWhere((element) => element.itemId == itemId);
      _saveItemsOnLocal();
      notifyListeners();
      return 'Delete Successfully';
    }
    return 'Could not delete item';
  }

  List<CardItem> search(String search) {
    return _items
        .where((item) =>
            (item.cardId != null &&
                item.cardId.toLowerCase().contains(search.toLowerCase())) ||
            (item.itemId != null &&
                item.itemId.toLowerCase().contains(search.toLowerCase())) ||
            (item.itemName != null &&
                item.itemName.toLowerCase().contains(search.toLowerCase())) ||
            (item.serialNumber != null &&
                item.serialNumber
                    .toLowerCase()
                    .contains(search.toLowerCase())) ||
            (item.price != null &&
                item.price.toLowerCase().contains(search.toLowerCase())))
        .toList();
  }
  
}
