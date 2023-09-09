import 'package:flutter/material.dart';
import 'package:shopping_app/itemstate_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Detail'),
        leading: IconButton(
          onPressed: () {
            final onBack = context.read<StateModel>();
            setState(() {
              onBack.navToIndex(0);
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _detail(),
    );
  }

  Widget _detail() {
    return Consumer<StateModel>(
      builder: (context, value, child) => ListView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        children: [
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(2),
              child: Image.network(
                value.detailItem['image_url'],
                height: 350,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value.detailItem['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final onSave = context.read<StateModel>();
                      onSave.favorite(value.detailItem);
                    },
                    icon: Icon(
                      value.items.any((element) => element
                              .toString()
                              .contains(value.detailItem.toString()))
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    color: value.items.any((element) => element
                            .toString()
                            .contains(value.detailItem.toString()))
                        ? Colors.red
                        : null,
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
            child: Text(
              value.detailItem['price'].toString(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  final onSave = context.read<StateModel>();
                  onSave.addToCart(value.detailItem);
                },
                child: const Text('Add to Cart')),
          )
        ],
      ),
    );
  }
}
