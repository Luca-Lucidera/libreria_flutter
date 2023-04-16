import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreria_flutter/model/dio_client.dart';
import 'package:libreria_flutter/model/library.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<User> _user;
  var _books;

  Future<User> getUser() async {
    final BaseClient client = BaseClient();
    try {
      await client.setupCookieForRequest();
      final res = await client.dio
          .get('https://mia-libreria.vercel.app/api/auth/session');
      return User.fromJson(res.data);
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _user = getUser();
    _books = Provider.of<Library>(context).fetchBooks();
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
            return HomeBody(books: Provider.of<Library>(context).list);
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
      ),
    );
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
            child: SizedBox(
              child: Text(
                book.title.length < 35
                    ? book.title
                    : book.title.substring(0, 35),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
                builder: (BuildContext context) => BookDialog(book: book),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookDialog extends StatefulWidget {
  const BookDialog({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  State<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  bool edit = false;
  late Book bookToEdit = Book.empty();
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController priceController = TextEditingController(text: "");

  @override
  void initState() {
    bookToEdit = Book.cloneWith(widget.book);
    titleController = TextEditingController(text: bookToEdit.title);
    priceController = TextEditingController(text: bookToEdit.price.toString());
    super.initState();
  }

  @override
  void dispose() {
    bookToEdit = Book.empty();
    titleController = TextEditingController(text: "");
    priceController = TextEditingController(text: "");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  child: !edit
                      ? Text(
                          widget.book.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : TextFormField(
                          controller: titleController,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: !edit
                    ? Text('Purchased: ${widget.book.purchased}')
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Purchased: ${bookToEdit.purchased}',
                            textAlign: TextAlign.center,
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              if (bookToEdit.purchased > 1) {
                                setState(() {
                                  bookToEdit.purchased--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              if (bookToEdit.purchased < 999) {
                                setState(() {
                                  bookToEdit.purchased++;
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: !edit
                    ? Text('Read: ${widget.book.read}')
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Read: ${bookToEdit.read}',
                            textAlign: TextAlign.center,
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              if (bookToEdit.read > 0) {
                                setState(() {
                                  bookToEdit.read--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              if (bookToEdit.purchased > bookToEdit.read) {
                                setState(() {
                                  bookToEdit.read++;
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: !edit
                    ? Text(widget.book.status)
                    : DropdownButton<String>(
                        value: bookToEdit.status,
                        items: const [
                          DropdownMenuItem(
                            value: "To Read",
                            child: Text("To Read"),
                          ),
                          DropdownMenuItem(
                            value: "Reading",
                            child: Text("Reading"),
                          ),
                          DropdownMenuItem(
                            value: "Compete",
                            child: Text("Complete"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            bookToEdit.status = value!;
                          });
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: !edit
                    ? Text(widget.book.type)
                    : DropdownButton<String>(
                        value: bookToEdit.type,
                        items: const [
                          DropdownMenuItem(
                            value: "Manga",
                            child: Text("Manga"),
                          ),
                          DropdownMenuItem(
                            value: "Novel",
                            child: Text("Novel"),
                          ),
                          DropdownMenuItem(
                            value: "Light Novel",
                            child: Text("Light Novel"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            bookToEdit.type = value!;
                          });
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: !edit
                    ? Text(widget.book.publisher)
                    : DropdownButton<String>(
                        value: bookToEdit.publisher,
                        items: const [
                          DropdownMenuItem(
                            value: "JPOP",
                            child: Text("JPOP"),
                          ),
                          DropdownMenuItem(
                            value: "Star Comics",
                            child: Text("Star Comics"),
                          ),
                          DropdownMenuItem(
                            value: "Planet Manga",
                            child: Text("Planet Manga"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            bookToEdit.publisher = value!;
                          });
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  child: !edit
                      ? Text(
                          '${widget.book.price}',
                          textAlign: TextAlign.center,
                        )
                      : SizedBox(
                          width: 100,
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: priceController,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: !edit
                    ? Text('Rating: ${widget.book.rating}/5')
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Rating: ${bookToEdit.rating}/5',
                            textAlign: TextAlign.center,
                          ),
                          IconButton.filledTonal(
                            onPressed: () {},
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: !edit
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            edit = true;
                          });
                        },
                        label: const Text("Edit"),
                        icon: const Icon(Icons.edit),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {
                              setState(() {
                                edit = false;
                              });
                            },
                            label: const Text("Close"),
                            icon: const Icon(Icons.close),
                          ),
                          FloatingActionButton.extended(
                            onPressed: () {
                              setState(() {
                                edit = false;
                              });
                            },
                            label: const Text("Save"),
                            icon: const Icon(Icons.save),
                          ),
                        ],
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
