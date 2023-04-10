import 'package:flutter/material.dart';

import '../model/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(book.title),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${book.publisher} ${book.price}€"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Purchased ${book.purchased}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Read ${book.purchased}/${book.purchased}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
