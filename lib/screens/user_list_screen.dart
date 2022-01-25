import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:ez_eats/screens/add_user_screen.dart';
import 'package:ez_eats/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'add_user_screen.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key? key}) : super(key: key);
  
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>{
  
  bool _fileExists = false;
  File _filePath = File("");

  // First initialization of _json (if there is no json in the file)
  List users_ = [];
  // Map<String, dynamic> _json = {};
  String _jsonString = "";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/users.json');
  }

  void writeJson(String name, dynamic restrictions) async {
    // Initialize the local _filePath
    final _filePath = await _localFile;
  ;
    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> _newJson = {"name": name, "restrictions": restrictions};
    // print('1.(writeJson) _newJson: $_newJson');

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    users_.add(_newJson);
    // _json.addAll(_newJson);
    // print('2.(writeJson) _json(updated): $users_');

    //3. Convert _json ->_jsonString
    _jsonString = jsonEncode(users_);
    // print('3.(writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    try {
      _filePath.writeAsString(_jsonString);
      // print("wrote to json");
    } catch (e) {
      print("tried writing did not work. File Error: $e");
    }
  }

  void readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;
    // print(_filePath.toString());

    // 0. Check whether the _file exists
    _fileExists = await _filePath.exists();
    // print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath.readAsString();
        setState(() {
          _jsonString = _jsonString;
        });
        // print('1.(readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        setState(() {
          users_ = jsonDecode(_jsonString);          
        });
        // print('2.(readJson) _json: $users_ \n - \n');
        // print(users_.length);
        // NAME
        // print(users_[1]['name']);
        // RESTRICTIONS LIST
        // print(users_[1]['restrictions']);
      } 
      catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }

  @override
  void initState() {
    super.initState();
    writeJson("Jimmy", ["Peanuts", "Tree nuts"]);
    writeJson("Abhishek", ["Vegetarian"]);

    readJson();
  }

  List userChecks = List.filled(20, false);

  @override
  Widget build(BuildContext context) {
    // print("before writing to json");
    // print(_json.toString());
    // print(2938478170481273);
    // _writeJson("i added this", ["add1", "add2", "add3"]);
    // print("after writing to json");
    // writeJson("Jimmy", ["peanuts", "tree nuts"]);
    // writeJson("Abhishek", ["vegetarian"]);

    readJson();
    //print(_users[0]);
    // _users = _json['users'];
    // print(_json[0]);
    // print(_users[0]['restrictions']);

    return Scaffold(
      appBar: AppBar(leading: null, title:  const Text("User List"), actions: []),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
          // height: 400,
          // width: 300,
          // use ListView or ListView.Builder

          // *********************************************************
          // FIND WAY TO USE LISTVIEW BUILDER TO ITERATE THROUGH JSON
          // *********************************************************
          
          // child: ListView.builder(
          //     itemCount: users_.length,
          //     itemBuilder: (context, i) {
          //       var user = users_[i];
          //       String name = user['name'];
          //       var restrictions = user['restrictions'];
          //       return _userTile(name, restrictions);
          //     }
          //   )

          child: Column(children: [
            Flexible(
              child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for(var i = 0; i<users_.length; i++) 
                  _userTile(users_[i]['name'], users_[i]['restrictions'], i)
                ]
              ),
            ),
            
            _addUserButton(context),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchScreen()));
              }, 
              child: const Text("Done"))
            ]
          )
        )
      )
    );
  }

  Widget _userTile(String name, List restrictions, int idx) {
    String rStr = restrictions.fold("",(prev, element) => '$prev, $element').substring(2);
    return CheckboxListTile(
      title:  Text(name), subtitle:  Text(rStr), 
      value: userChecks[idx],
      onChanged: (value) {
        setState(() {
          userChecks[idx] = value!;
        });
      }
    );
  }

  Widget _addUserButton(BuildContext context) {
    // use either OutlinedButton or ElevatedButton
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 95),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUserScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text("Add User"))
    );
  }

  
}
