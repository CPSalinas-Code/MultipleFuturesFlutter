import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spring_app/endpoints/constants.dart' as endpoints;

class DataBaseHelper {
  ///Funcion de agregacion de usuarios hacia api SpringBoot
  /// [addUser] http.response.
  /// Agregar usuario a bd mysql atravez de SpringBoot CRUD

  Future<http.Response> addUser (String nameController, String emailController, String addressController) async{
    Map data = {
      'name': nameController,
      'email': emailController,
      'address': addressController
    };

    var body = json.encode(data);
    var response = await http.post(Uri.parse("http://192.168.0.106:8787/addUser"),
    headers: {"Content-Type":"application/json"},body: body);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<http.Response> deleteUser(int idUser) async{
    var response = await http.delete(Uri.parse('${endpoints.ApiConstants.deletEndPoint}/$idUser'));
    print(response.statusCode);
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print('${endpoints.ApiConstants.deletEndPoint}/$idUser');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print(response.body);
    return response;
  }

}