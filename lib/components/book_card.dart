import 'package:flutter/material.dart';

import '../model/book.dart';
import 'book_dialog.dart';

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
