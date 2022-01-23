// import 'package:ez_eats/users.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
  
}

class _AddUserScreenState extends State<AddUserScreen>{
  
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

  TextEditingController controller = TextEditingController();

  Map<String, bool> responses = {
    'Dairy': false,
    'Egg': false,
    'Fish': false,
    'Mushroom': false,
    'Peanuts': false,
    'Sesame': false,
    'Shellfish': false,
    'Soy': false,
    'Tree Nut': false,
    'Vegan': false,
    'Vegetarian': false,
    'Wheat': false
  };

  @override
  Widget build(BuildContext context) {
    readJson();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(leading: null, title: const Text("Add User"), actions: []),
      body: Center(
          child: Container(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 10, bottom: 10),
              // could use ListView.Builder
              child: Column(
                children: [
                  _nameInput(),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView(
                      children: responses.keys.map((String key) {
                        return CheckboxListTile(
                          title: Text(key),
                          value: responses[key],
                          onChanged: (bool? value) {
                            setState(() {
                              responses[key] =  value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  _saveButton(context)
              ]))),
    );
  }

  Widget _nameInput(){
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: const InputDecoration(
          // PUT OTHER DECORATORS HERE MAYBE
          labelText: "Name"
        ),
        controller: controller
      )
    );
  }
  
  // bool? val = false;
  // Widget _restrictionTile(String label) {
    
  //   return CheckboxListTile(
  //     title: Text(label, style: const TextStyle()),
  //     secondary: null,
  //     controlAffinity: ListTileControlAffinity.leading,
  //     // activeColor: ,
  //     // checkColor: ,
  //     value: val,
  //     onChanged: (bool? value) {
  //       setState(() {
  //         // replace "val" with the corresponing JSON field
  //         val = value;
  //       });
  //     },
  //   );
  // }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          // ********************
          // WRITE TO JSON
          // ********************
          String _name = controller.text;
          List restrictions = [];
          for(String key in responses.keys){
            if(responses[key]!) {
              restrictions.add(key);
            }
          }
          writeJson(_name, restrictions);
          Navigator.pop(context);

        },
        icon: const Icon(Icons.save_outlined),
        label: const Text("Save"));
  }
}
