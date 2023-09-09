import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/cartpage.dart';
import 'package:shopping_app/checkOutPage.dart';
import 'package:shopping_app/detailPage.dart';
import 'package:shopping_app/homepage.dart';
import 'package:shopping_app/savedpage.dart';

class StateModel extends ChangeNotifier {
  final List _allItems = [];
  late final _savedItems = [];
  late Map _detailItem = {};
  late final List _cartItem = [];
  late List _cartShowItem = [];
  int _navIndex = 0;
  num _totalPrice = 0;
  int get navIndex => _navIndex;
  num get totalPrice => _totalPrice;
  List get items => _savedItems;
  List get allItems => _allItems;
  List get cartItem => _cartItem;
  List get cartShowItem => _cartShowItem;
  get detailItem => _detailItem;
  get widGetOption => _widgetOption;

  static final Set<Widget> _widgetOption = <Widget>{
    const MaterialApp(
      home: ItemList(),
    ),
    const MaterialApp(
      home: SavedPage(),
    ),
    const MaterialApp(
      home: CartPage(),
    ),
    const MaterialApp(
      home: DetailPage(),
    ),
    const MaterialApp(
      home: CheckOutPage(),
    )
  };

  int navToIndex(int index) {
    notifyListeners();
    return _navIndex = index;
  }

  Text getTotalPrice() {
    num total = 0;
    for (var i = 0; i < _cartItem.length; i++) {
      if (total == 0) {
        total = _cartItem[i]['price'];
      } else {
        total = total + _cartItem[i]['price'];
      }
    }
    _totalPrice = total;
    return Text(
      '$total \$',
      style: const TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.brown),
    );
  }

  Text countOccurrencesUsingLoop(String name) {
    if (cartItem.isEmpty) {
      return const Text('0');
    }

    int count = 0;
    for (int i = 0; i < cartItem.length; i++) {
      if (cartItem[i]['name'] == name) {
        count++;
      }
    }
    final jsonList = cartItem.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();
    _cartShowItem = result;
    return Text(
      count.toString(),
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  void removeFromCart(data) {
    _cartItem.remove(data);
  }

  void removeAllFromCart(data) {
    // _cartShowItem.remove(data);
    for (int i = 0; i < _cartShowItem.length; i++) {
      if (_cartShowItem[i]['name'] == data['name']) {
        _cartShowItem.remove(_cartShowItem[i]);
        _cartItem.remove(data);
      }
    }
  }

  void getDetailItem(data) {
    _detailItem = data;
  }

  void addToCart(data) {
    _cartItem.add(data);
    countOccurrencesUsingLoop(data['name']);
  }

  void favorite(itemData) {
    if (_savedItems.any((element) =>
        element['id'].toString().contains(itemData['id'].toString()))) {
      _savedItems.remove(itemData);
    } else {
      _savedItems.add(itemData);
    }

    notifyListeners();
  }
}
