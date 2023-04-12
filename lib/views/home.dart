import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../model/book.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> _books;
  late Future<User> _user;

  Future<List<Book>> retriveBooks() async {
    final dio = Dio();
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
    await jar.loadForRequest(Uri.parse("https://mia-libreria.vercel.app"));
    try {
      final res = await dio.get('https://mia-libreria.vercel.app/api/books');
      return res.data.map<Book>((json) => Book.fromJson(json)).toList();
    } catch (error) {
      if (context.mounted) {
        await Navigator.of(context).pushReplacementNamed('/login');
      }
      rethrow;
    }
  }

  Future<User> retriveUser() async {
    final dio = Dio();
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
    await jar.loadForRequest(Uri.parse("https://mia-libreria.vercel.app"));
    try {
      final res =
          await dio.get('https://mia-libreria.vercel.app/api/auth/session');
      return User.fromJson(res.data);
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _books = retriveBooks();
    _user = retriveUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: _user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Your library ${snapshot.data!.name}');
              }
              return const Text('Your library');
            },
          ),
        ),
        body: FutureBuilder(
          future: _books,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeBody(books: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: BottomAppBar(
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
                  builder: (BuildContext context) => const Text('pippo'),
                ),
              ),
            ],
          ),
        ));
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key, required this.books}) : super(key: key);
  final List<Book> books;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: SearchBar(),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
            ),
            itemCount: widget.books.length,
            itemBuilder: (BuildContext context, int index) {
              return BookCard(
                book: widget.books.elementAt(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              book.title.substring(
                  0, book.title.length > 16 ? 16 : book.title.length),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text('Purchased ${book.purchased}'),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text('${book.price}€'),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: FilledButton(
              child: const Text("Show more"),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          book.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Purchased: ${book.purchased}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Read: ${book.read}'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(book.status),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(book.type),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(book.publisher),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${book.price}€'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${book.rating}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
