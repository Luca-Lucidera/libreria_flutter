import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String jwt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      jwt: json['jwt'],
    );
  }

  const User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.jwt,
  });
}
