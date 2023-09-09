import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/itemstate_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
        builder: (context, value, child) => Scaffold(
            body: Center(
              child: value.widGetOption.elementAt(value.navIndex),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                height: 105,
                color: Colors.black,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (value.navIndex < 3)
                            GNav(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                backgroundColor: Colors.black,
                                color: Colors.white,
                                activeColor: Colors.white,
                                tabBackgroundColor: Colors.grey.shade800,
                                padding: const EdgeInsets.all(20),
                                gap: 10,
                                onTabChange: (index) {
                                  final onNav = context.read<StateModel>();
                                  setState(() {
                                    onNav.navToIndex(index);
                                  });
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
                        ])),
              ),
            )));
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

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(), () {
      readJson();
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
    return Consumer<StateModel>(
        builder: (context, value, child) => GridView.count(
              childAspectRatio: 0.53,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < _items.length; i++)
                  Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
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
                                value.items.any((element) => element['id']
                                        .toString()
                                        .contains(_items[i]['id'].toString()))
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () {
                                final onSave = context.read<StateModel>();
                                onSave.favorite(_items[i]);
                              },
                              color: value.items.any((element) => element['id']
                                      .toString()
                                      .contains(_items[i]['id'].toString()))
                                  ? Colors.red
                                  : null,
                            )
                          ],
                        ),
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          onTap: () {
                            final onNav = context.read<StateModel>();
                            setState(() {
                              onNav.navToIndex(3);
                            });
                            value.getDetailItem(_items[i]);
                          },
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Price: ${_items[i]['price'].toString()}',
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 15),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined),
                                onPressed: () {
                                  final onAdd = context.read<StateModel>();
                                  setState(() {
                                    onAdd.addToCart(_items[i]);
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ));
  }
}
