import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'savedpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectionIndex = 0;

  static final Set<Widget> _widgetOption = <Widget>{
    const MaterialApp(
      home: ItemList(),
    ),
    const MaterialApp(
      home: SavedPage(),
    ),
    Container(
      color: Colors.green,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(_selectionIndex),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.all(20),
              gap: 10,
              onTabChange: (index) {
                setState(() {
                  _selectionIndex = index;
                });
                print(_selectionIndex);
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Favorite',
                ),
                GButton(
                  icon: Icons.shopping_cart_rounded,
                  text: "Cart",
                ),
              ]),
        ),
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List _items = [];
  late bool _isLoading = false;
  List _savedItems = [];

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(), () {
      readJson();
      // print(_savedItems);
      // if (_savedItems.isEmpty) {
      //   _savedItems = [];
      // }
      // print(_savedItems);
      _isLoading = false;
    });
    super.initState();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/list.json');
    final data = await json.decode(response);
    setState(() {
      _items = ((data["product_items"] ?? []) as List);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_isLoading) {
      body = const Center(
        child: Text('Loading'),
      );
    } else {
      body = _list();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('For You',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      body: body,
    );
  }

  Widget _list() {
    return GridView.count(
      childAspectRatio: 0.58,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < _items.length; i++)
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                    ),
                    IconButton(
                      icon: Icon(
                        _savedItems.contains(_items[i]['name'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_savedItems.contains(_items[i]['name'])) {
                            _savedItems.remove(_items[i]['name']);
                          } else {
                            _savedItems.add(_items[i]['name']);
                          }
                        });
                      },
                      color: _savedItems.contains(_items[i]['name'])
                          ? Colors.red
                          : null,
                    )
                  ],
                ),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    child: Image.network(
                      _items[i]['image_url'],
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _items[i]['name'],
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Price: ${_items[i]['price'].toString()}',
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
