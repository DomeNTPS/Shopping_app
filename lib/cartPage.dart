import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/itemstate_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, value, child) => Scaffold(
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: const BoxDecoration(color: Colors.black12),
                child: Column(
                  children: [_cartItem()],
                ),
              )
            ],
          ),
          bottomNavigationBar: _cartResult()),
    );
  }

  Widget _cartItem() {
    return Consumer<StateModel>(
      builder: (context, value, child) => Column(
        children: [
          for (int i = 0; i < value.cartShowItem.length; i++)
            if (value.cartItem.isNotEmpty)
              Slidable(
                key: Key('$i'),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          final onRemove = context.read<StateModel>();
                          setState(() {
                            onRemove.removeAllFromCart(value.cartItem[i]);
                          });
                        });
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                    )
                  ],
                ),
                child: Container(
                  height: 200,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Container(
                          height: 70,
                          width: 70,
                          margin: const EdgeInsets.only(right: 15),
                          child: Image.network(
                            value.cartItem[i]['image_url'],
                            height: 350,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value.cartItem[i]['name'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  overflow: TextOverflow.visible),
                            ),
                            Text(
                              value.cartItem[i]['price'].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 1,
                                            blurRadius: 10)
                                      ]),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      CupertinoIcons.minus,
                                    ),
                                    onPressed: () {
                                      final onRemove =
                                          context.read<StateModel>();
                                      setState(() {
                                        onRemove
                                            .removeFromCart(value.cartItem[i]);
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: value.countOccurrencesUsingLoop(
                                      value.cartItem[i]['name']),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 1,
                                            blurRadius: 10)
                                      ]),
                                  child: IconButton(
                                    icon: const Icon(CupertinoIcons.plus),
                                    onPressed: () {
                                      final onAdd = context.read<StateModel>();
                                      setState(() {
                                        onAdd.addToCart(value.cartItem[i]);
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
        ],
      ),
    );
  }

  Widget _cartResult() {
    return Consumer<StateModel>(
      builder: (context, value, child) => BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  value.getTotalPrice()
                ],
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                    onPressed: () {
                      final onCheckout = context.read<StateModel>();
                      onCheckout.navToIndex(4);
                    },
                    child: const Text('Checkout')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
