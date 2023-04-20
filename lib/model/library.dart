import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/dio_client.dart';

import 'book.dart';

class Library extends ChangeNotifier {
  List<Book> _list = [];

  UnmodifiableListView<Book> get list => UnmodifiableListView(_list);

  final BaseClient _client = BaseClient();

  List<Book> filterBooks(String sType, String sStatus, String sPublisher) {
    if (sType == "All" && sStatus == "All" && sPublisher == "All") return list;
    return list.where((element) {
      if (sType != "All" && element.type != sType) return false;
      if (sPublisher != "All" && element.publisher != sPublisher) return false;
      if (sStatus != "All" && element.status != sStatus) return false;
      return true;
    }).toList();
  }

  Future<void> fetchBooks() async {
    await _client.setupCookieForRequest();
    final response = await _client.dio.get('/api/books');
    final body = response.data;
    final listOfBooks = body.map<Book>((book) => Book.fromJson(book)).toList();
    _list = listOfBooks;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await _client.setupCookieForRequest();
    await _client.dio.post('/api/books', data: book.toJson());
    await fetchBooks();
  }

  Future<void> updateBook(Book book) async {
    await _client.setupCookieForRequest();
    await _client.dio.put('/api/books', data: book.toJson());
    await fetchBooks();
  }

  Future<void> deleteBook(Book book) async {
    await _client.setupCookieForRequest();
    await _client.dio.delete(
      '/api/books/${book.id}',
    );
    await fetchBooks();
  }
}
