import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/itemstate_model.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      body: _list(),
    );
  }

  Widget _list() {
    return Consumer<StateModel>(
        builder: (context, value, child) => GridView.count(
              childAspectRatio: 0.53,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < value.items.length; i++)
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
                                        .contains(value.items[i]['id'].toString()))
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () {
                                final onSave = context.read<StateModel>();
                                onSave.favorite(value.items[i]);
                              },
                              color: value.items.any((element) => element['id']
                                      .toString()
                                      .contains(value.items[i]['id'].toString()))
                                  ? Colors.red
                                  : null,
                            )
                          ],
                        ),
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            child: Image.network(
                              value.items[i]['image_url'],
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value.items[i]['name'],
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
                                  'Price: ${value.items[i]['price'].toString()}',
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 15),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined),
                                onPressed: () {},
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
