import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/book.dart';
import '../model/filter.dart';
import '../model/library.dart';

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
                                            "Do you really want to delete ${widget.book.title}"),
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
                                                .tertiaryContainer,
                                            extendedTextStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onTertiaryContainer,
                                            ),
                                          )
                                        ],
                                      ),
                                    ).then(
                                      (value) => Navigator.of(context).pop(),
                                    ),
                            icon: const Icon(Icons.delete),
                            label: const Text("Elimina"),
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
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
