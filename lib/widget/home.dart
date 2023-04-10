import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < 30; i++) {
      children.add(const BookCard());
    }
    return Container(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchBar(),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Call of the night"),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("JPOP 6,50€"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Purchased 7"),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Read 5/7"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
