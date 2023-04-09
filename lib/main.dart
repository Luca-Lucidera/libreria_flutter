import 'package:flutter/material.dart';
import 'package:libreria_flutter/widget/login_form.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      title: "Your library",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Your library"),
            ),
            body: const LoginForm(),
          );
        },
      },
    );
  }
}
