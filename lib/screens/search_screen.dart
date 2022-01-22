import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget{
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Container(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children: const [
            // ListTile(title: Text("HELLO WORLD")),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                labelText: "Search"
                ),
              )
            ],
          )
        ),
      )
    );
  }
  
}