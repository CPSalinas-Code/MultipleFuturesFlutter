import 'package:flutter/material.dart';
import 'package:spring_app/controllers/databasehelpers.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final DataBaseHelper _dataBaseHelper = DataBaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddUsers Screen'),
        ),
        body: Container(
            child: ListView(
          padding:
              const EdgeInsets.only(top: 62, left: 12, right: 12, bottom: 12),
          children: [
            Container(
              height: 50,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'name',
                  hintText: 'Product Name',
                  icon: Icon(Icons.person),
                ),
              ),
            ),
            Container(
              height: 50,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'email',
                  hintText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
            ),
            Container(
              height: 50,
              child: TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'address',
                  hintText: 'Adress',
                  icon: Icon(Icons.place),
                ),
              ),
            ),
            Padding(padding: new EdgeInsets.only(top: 44)),
            Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: (() {
                    _dataBaseHelper.addUser(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        addressController.text.trim());
                    Navigator.pop(context, true);
                  }),
                  child: const Text('Agregar'),
                ))
          ],
        )));
  }
}
