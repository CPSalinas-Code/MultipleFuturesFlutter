import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spring_app/controllers/databasehelpers.dart';
import 'package:spring_app/endpoints/constants.dart';
import 'package:spring_app/models/reqres_model.dart';
import 'package:spring_app/views/add_user_screen.dart';

enum SingingCharacter { saldo, consumo }

class ListViewUsers extends StatefulWidget {
  const ListViewUsers({super.key});

  @override
  State<ListViewUsers> createState() => _ListViewUsersState();
}

class _ListViewUsersState extends State<ListViewUsers> {
  //List? dataRealApi;
  late bool saldo = false;
  late bool consumo = false;

  Future<List> getDataRealAPi() async {
    debugPrint(ApiConstants.usersEndPoint);
    final response =
        await http.get(Uri.parse("http://192.168.0.106:8787/users"));
    return json.decode(response.body);
  }

  Future<Welcome> getDataOnlineApi() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    return welcomeFromJson(response.body);
  }

  @override
  void initState() {
    super.initState();
    getDataRealAPi();
    getDataOnlineApi();
  }

  SingingCharacter? _character = SingingCharacter.saldo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api SpringBoot with Mysql'),
        actions: [
          ElevatedButton(
              onPressed: () => _navigateAddUser(context),
              child: const Icon(Icons.add)),
          ElevatedButton(onPressed: () {}, child: const Icon(Icons.edit))
        ],
      ),
      body: Column(
        children: [
          Column(
            children: <Widget>[
              ListTile(
                title: const Text('SALDO'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.saldo,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('CONSUMO'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.consumo,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder<List>(
              //future: //getDataRealAPi(),
              future: Future.wait([
                getDataRealAPi(),
                getDataOnlineApi(),
              ]),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? _character==SingingCharacter.saldo? ItemList(
                        list: snapshot.data![0],
                      ): _ListaUsuarios(snapshot.data![1].data)
                    : const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }

  _navigateAddUser(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddUserScreen()));

    if (result) {
      setState(() {});
    }
  }

  navigateDeleteUser(BuildContext context) async {
    if (true) {
      setState(() {});
    }
  }
}

class _ListaUsuarios extends StatelessWidget {
  final List<Usuario> usuarios;

 const _ListaUsuarios(this.usuarios);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: usuarios.length,
      itemBuilder: (BuildContext context, int  index) {
        final usuario = usuarios[index];
        return FadeIn(
          delay: Duration(milliseconds: 100 *index),
          child: ListTile(
            title: Text('${usuario.firstName} ${usuario.lastName}'),
            subtitle: Text(usuario.email),
            trailing: Image.network(usuario.avatar),
          ),
        );
      },
    );
  }
}

class ItemList extends StatefulWidget {
  final List? list;
  const ItemList({this.list});

  @override
  State<StatefulWidget> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final DataBaseHelper _dataBaseHelper = DataBaseHelper();

  //_ItemListState(List? list);
  //late List? list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        //reverse: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.list == null ? 0 : widget.list!.length,
        itemBuilder: ((context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 130.3,
                    child: Card(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        widget.list![index]['name'].toString(),
                                        style: const TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(widget.list![index]['email'].toString(),
                                  style: const TextStyle(fontSize: 20.0)),
                              Text(widget.list![index]['address'].toString(),
                                  style: const TextStyle(fontSize: 20.0)),
                              /*Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(list![index]['id'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0))                            
                              )*/
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              _dataBaseHelper.deleteUser(int.parse(
                                  widget.list![index]['id'].toString()));
                              setState(() {});
                            },
                            icon: const Icon(
                              size: 40,
                              color: Colors.white,
                              Icons.delete,
                            ),
                          )
                          //ElevatedButton(onPressed: (){}, child: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
