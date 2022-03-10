import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

class SearchScreen extends StatefulWidget{
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();

}

class _SearchScreenState extends State<SearchScreen>{
  TextEditingController clr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Container(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children:  [
            // ListTile(title: Text("HELLO WORLD")),
            TextField(
              controller: clr,
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                labelText: "Search"
                ),
              ),
            restaurantList()
            
            ],
          
          )
        ),
      )
    );
  }
  
  Widget restaurantCard(String name){
    String imgPath = '';
    bool alreadySaved = Hive.box("favorites").get(name);
    return SizedBox(
      width: 300,
      // height: 150,
      child: Card(
        child: InkWell(
          splashColor: Colors.grey.withAlpha(50),
          onTap: () {

          },
          child: Column(
            children: [
              // Image.asset(imgPath),
              Text(name, style: const TextStyle(fontSize: 18, fontFamily: "")),
              Text("DESCRIPTION", style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      print('BUTTON PRESSED');
                    },
                    child: Text("Button 1", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[500]))
                  ),
                  IconButton(
                    onPressed: () {
                      print('ICON PRESSED'); 
                      setState(() {
                          Hive.box("favorites").put(name, !Hive.box("favorites").get(name));
                      });
                    },
                    icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border_sharp, color: alreadySaved ? Colors.red : null))
                ],
              )
            ]
          )         
        )
      )
    );
  }

  Widget restaurantList(){
    return Column(
      children: [
        restaurantCard("McDonald's"),
        restaurantCard("Panera Bread")
      ],
    );
  }
  
}