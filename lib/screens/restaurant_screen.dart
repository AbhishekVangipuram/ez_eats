import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
            body: SafeArea(
      child: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_sharp)),
              const IconButton(
                  onPressed: null, icon: Icon(Icons.circle_outlined))
            ],
          ),
          SizedBox(
              height: 200,
              width: 350,
              child: Image.asset('assets/images/mcdonalds/mcdonalds-card.jpg',
                  height: 200, width: null, fit: BoxFit.fill))
        ],
      ),
    )));
  }
}
