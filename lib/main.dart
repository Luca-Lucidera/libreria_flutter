import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/filter.dart';
import 'package:libreria_flutter/model/library.dart';
import 'package:libreria_flutter/views/home.dart';
import 'package:libreria_flutter/views/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Library()),
        ChangeNotifierProvider(create: (context) => Filters()),
      ],
      child: const MainApp(),
    ),
  );
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
        '/test': (BuildContext context) => const TestPage(),
      },
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Library>(builder: (context, library, child) {
      return Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                library.fetchBooks();
                print(library.list.length);
              },
              child: const Text("premi"),
            ),
            SizedBox(
              child: Text('${library.list.length}'),
            ),
          ],
        ),
      );
    });
  }
}
