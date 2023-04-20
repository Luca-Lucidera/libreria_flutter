import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/dio_client.dart';
import 'package:libreria_flutter/model/library.dart';
import 'package:provider/provider.dart';
import '../components/book_card.dart';
import '../components/book_dialog.dart';
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
