import 'package:flutter/material.dart';
import 'widget/home.dart';
import 'widget/custom_bottom_app_bar.dart';

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
      home: Scaffold(
        appBar: AppBar(
          elevation: 6,
          leading: const Icon(Icons.menu_book_rounded),
          title: const Text("Your library"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: const HomePage(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const CustomBottomAppBar(),
      ),
    );
  }
}
