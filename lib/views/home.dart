import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreria_flutter/model/dio_client.dart';
import 'package:libreria_flutter/model/library.dart';
import 'package:provider/provider.dart';
import '../model/book.dart';
import '../model/filter.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<User> _user;
  late Future<void> _books;

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
    try {
      _user = getUser();
      _books = Provider.of<Library>(context, listen: false).fetchBooks();
      Provider.of<Filters>(context, listen: false).fetchFilters();
    } catch (error) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("Torna alla login o riavvia l'app");
              }
              return Text('Your library ${snapshot.data!.name}');
            }
            return const Text('Your library');
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final BaseClient client = BaseClient();
                await client.setupCookieForRequest();
                await client.dio.post('/api/auth/logout');
              } catch (error) {
                print(error.toString());
              } finally {
                if (mounted) {
                  await Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: ElevatedButton(
                  child: const Text(
                      'Si è verificato un errore, premi per tornare alla login'),
                  onPressed: () async {
                    await Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              );
            }
            return const HomeBody();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => BookDialog(book: Book.empty(), isNewBook: true),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
            SizedBox(
              child: IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Status"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: DropdownButton(
                                    value: Provider.of<Filters>(context)
                                        .selectedStatus,
                                    items: Provider.of<Filters>(context)
                                        .status
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      Provider.of<Filters>(context,
                                              listen: false)
                                          .setSelectedStatus(value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Type"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: DropdownButton(
                                    value: Provider.of<Filters>(context)
                                        .selectedType,
                                    items: Provider.of<Filters>(context)
                                        .type
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      Provider.of<Filters>(context,
                                              listen: false)
                                          .setSelectedType(value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Publisher"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: DropdownButton(
                                    value: Provider.of<Filters>(context)
                                        .selectedPublisher,
                                    items: Provider.of<Filters>(context)
                                        .publisher
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      Provider.of<Filters>(context,
                                              listen: false)
                                          .setSelectedPublisher(value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sType = Provider.of<Filters>(context).selectedType;
    final sPublisher = Provider.of<Filters>(context).selectedPublisher;
    final sStatus = Provider.of<Filters>(context).selectedStatus;
    final books =
        Provider.of<Library>(context).filterBooks(sType, sStatus, sPublisher);
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
            itemCount: books.length,
            itemBuilder: (BuildContext context, int index) {
              return BookCard(
                book: books.elementAt(index),
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
                builder: (BuildContext context) =>
                    BookDialog(book: book, isNewBook: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookDialog extends StatefulWidget {
  const BookDialog({Key? key, required this.book, required this.isNewBook})
      : super(key: key);
  final Book book;
  final bool isNewBook;

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
    if (!widget.isNewBook) {
      bookToEdit = Book.cloneWith(widget.book);
    } else {
      edit = true;
    }
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
                          onChanged: (value) =>
                              bookToEdit.title = titleController.text,
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
                        items: Provider.of<Filters>(context, listen: false)
                            .status
                            .where((element) => element != "All")
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
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
                        items: Provider.of<Filters>(context, listen: false)
                            .type
                            .where((element) => element != "All")
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
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
                        items: Provider.of<Filters>(context, listen: false)
                            .publisher
                            .where((element) => element != "All")
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]"))
                            ],
                            controller: priceController,
                            onChanged: (value) =>
                                bookToEdit.price = double.parse(value),
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
                            onPressed: () {
                              if (bookToEdit.rating > 0) {
                                setState(() {
                                  bookToEdit.rating -= 0.5;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              if (bookToEdit.rating < 5) {
                                setState(() {
                                  bookToEdit.rating += 0.5;
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: !edit
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: bookToEdit.id == ""
                                ? null
                                : () => showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Delete this book"),
                                        content: Text(
                                            "Do you really want to delete ${widget.book}"),
                                        actions: [
                                          FloatingActionButton.extended(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Icon(Icons.arrow_back),
                                            label: const Text("go back"),
                                          ),
                                          FloatingActionButton.extended(
                                            onPressed: bookToEdit.id == ""
                                                ? null
                                                : () {
                                                    Provider.of<Library>(
                                                            context,
                                                            listen: false)
                                                        .deleteBook(
                                                            widget.book);
                                                    Navigator.of(context).pop();
                                                  },
                                            icon: const Icon(Icons.delete),
                                            label: const Text("delete"),
                                            backgroundColor: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .onError,
                                          )
                                        ],
                                      ),
                                    ).then(
                                      (value) => Navigator.of(context).pop(),
                                    ),
                            icon: const Icon(Icons.delete),
                            label: const Text("Elimina"),
                            backgroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                          FloatingActionButton.extended(
                            onPressed: () {
                              setState(() {
                                edit = true;
                              });
                            },
                            label: const Text("Edit"),
                            icon: const Icon(Icons.edit),
                          ),
                        ],
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
                            backgroundColor: Colors.green[800],
                            onPressed: () async {
                              if (!widget.isNewBook) {
                                await Provider.of<Library>(context,
                                        listen: false)
                                    .updateBook(bookToEdit);
                              } else {
                                await Provider.of<Library>(context,
                                        listen: false)
                                    .addBook(bookToEdit);
                              }
                              setState(() {
                                edit = false;
                              });
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            label: const Text("Save"),
                            icon: const Icon(Icons.save),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
