// import 'package:ez_eats/users.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({Key? key}) : super(key: key);

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
              child: ListView(children: [
                _restrictionTile("Vegetarian", false),
                _restrictionTile("Vegan", false),
                _restrictionTile("Dairy", false),
                _restrictionTile("Soy", false),
                _saveButton()
              ]))),
    );
  }

  Widget _restrictionTile(String label, bool? value) {
    return CheckboxListTile(
        value: value,
        onChanged: (bool? val) {
          val = val!;
        });
  }

  Widget _saveButton() {
    return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.save_outlined),
        label: const Text("Save"));
  }
}
