import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/book.dart';
import 'book_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> futureBook;

  Future<List<Book>> getBook() async {
    final response = await http
        .get(Uri.https("mia-libreria.vercel.app", "/api/books"), headers: {
      "cookie":
          "session=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI5MzBmOTJiNi1jNmU1LTQ4ZGEtYmMyMi01MTYxY2ZjOTc1ZDgiLCJpYXQiOjE2ODExMzM3MTEsImV4cCI6MTY4MTIyMDExMSwiYXVkIjoibGEtdHVhLWxpYnJlcmlhIiwiaXNzIjoibGEtdHVhLWxpYnJlcmlhLWFwaSJ9.k8Vlfhf8jAkAj6sysZ--on5GKkJChFPw7_8ECD66w2Y"
    });
    List<Book> books = jsonDecode(response.body)
        .map<Book>((json) => Book.fromJson(json))
        .toList();
    return books;
  }

  @override
  void initState() {
    super.initState();
    futureBook = getBook();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBook,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchBar(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return BookCard(
                      book: snapshot.data![index],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
