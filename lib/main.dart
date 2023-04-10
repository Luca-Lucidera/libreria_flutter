import 'package:flutter/material.dart';
import 'package:libreria_flutter/widget/home.dart';

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

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => Container(
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Filter"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownMenu(
                        label: Text('Type'),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownMenu(
                        label: Text('Status'),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownMenu(
                        label: Text('Publisher'),
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                          DropdownMenuEntry(
                            label: "Manga",
                            value: "Manga",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
