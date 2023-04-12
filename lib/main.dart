import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/user.dart';
import 'package:libreria_flutter/views/home.dart';
import 'package:libreria_flutter/views/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      title: "Your library",
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
      },
    );
  }
}
