import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  String _name = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  String _jwt = "";

  User();

  User.initialize(
      String name, String lastName, String email, String password, String jwt) {
    _name = name;
    _lastName = lastName;
    _email = email;
    _password = password;
    _jwt = jwt;
  }

  void fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _lastName = json['lastName'];
    _email = json['email'];
    _password = json['password'];
    _jwt = json['jwt'];
    notifyListeners();
  }

  String get getJwt => _jwt;

  String get getName => _name;

  String get getLastName => _lastName;

  String get getEmail => _email;

  String get getPassword => _name;
}
