// import 'package:ez_eats/users.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
  
}

class _AddUserScreenState extends State<AddUserScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      children: [
                        _restrictionTile("Vegetarian"),
                        _restrictionTile("Vegan"),
                        _restrictionTile("Dairy"),
                        _restrictionTile("Soy"),
                        _restrictionTile("Soy"),
                        _restrictionTile("Soy"),
                        _restrictionTile("SoyAAAAAAAA"),
                        _restrictionTile("SoyBBBBBBBB"),

                      ],
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
        onTap: () {

        },
      )
    );
  }

  Widget _restrictionTile(String label) {
    bool? val = false;
    return CheckboxListTile(
      title: Text(label, style: const TextStyle()),
      value: val,
      onChanged: (bool? value) {
        setState(() {
          val = value;
        });
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          // ********************
          // WRITE TO JSON
          // ********************

          Navigator.pop(context);

        },
        icon: const Icon(Icons.save_outlined),
        label: const Text("Save"));
  }
}
