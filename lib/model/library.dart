import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/dio_client.dart';

import 'book.dart';

class Library extends ChangeNotifier {
  List<Book> _list = [];

  UnmodifiableListView<Book> get list => UnmodifiableListView(_list);

  Future<void> fetchBooks() async {
    BaseClient client = BaseClient();
    await client.setupCookieForRequest();
    final response = await client.dio.get('/api/books');
    final body = response.data;
    final listOfBooks = body.map<Book>((book) => Book.fromJson(book)).toList();
    _list = listOfBooks;
    notifyListeners();
  }
}
