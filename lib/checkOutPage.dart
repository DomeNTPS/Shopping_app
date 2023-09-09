import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shopping_app/itemstate_model.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StateModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Checkout'),
          leading: IconButton(
            onPressed: () {
              final onBack = context.read<StateModel>();
              setState(() {
                onBack.navToIndex(2);
              });
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Consumer<StateModel>(
          builder: (context, value, child) => Container(
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                QrImageView(
                    data:
                        'https://payment.spw.challenge/checkout?price=${value.totalPrice}'),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  child: Row(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
