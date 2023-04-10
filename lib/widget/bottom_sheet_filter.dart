import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/filters.dart';

class BottomSheetFilter extends StatefulWidget {
  const BottomSheetFilter({
    super.key,
  });

  @override
  State<BottomSheetFilter> createState() => _BottomSheetFilterState();
}

class _BottomSheetFilterState extends State<BottomSheetFilter> {
  late Future<Filters> futureType;
  late Future<Filters> futureStatus;
  late Future<Filters> futurePublisher;

  Future<Filters> getBookType() async {
    final url = Uri.https("mia-libreria.vercel.app", "/api/filter/type");
    final response = await http.get(url, headers: {});
    if (response.statusCode != 200) {
      throw Exception("Error: ${response.statusCode}");
    }
    return Filters.fromJson(jsonDecode(response.body));
  }

  Future<Filters> getBookStatus() async {
    final url = Uri.https("mia-libreria.vercel.app", "/api/filter/status");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception("Error: ${response.statusCode}");
    }
    return Filters.fromJson(jsonDecode(response.body));
  }

  Future<Filters> getBookPublisher() async {
    final url = Uri.https("mia-libreria.vercel.app", "/api/filter/publisher");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception("Error: ${response.statusCode}");
    }
    return Filters.fromJson(jsonDecode(response.body));
  }

  @override
  void initState() {
    super.initState();
    futureType = getBookType();
    futureStatus = getBookStatus();
    futurePublisher = getBookPublisher();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Filter"),
          ),
          FutureBuilder(
            future: futureType,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DropdownMenuEntry> entry = snapshot.data!.filters
                    .map((e) => DropdownMenuEntry(value: Text(e), label: e))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu(
                    label: const Text("Type"),
                    dropdownMenuEntries: entry,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return const Text("Loading the types...");
              }
            },
          ),
          FutureBuilder(
            future: futureStatus,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DropdownMenuEntry> entry = snapshot.data!.filters
                    .map((e) => DropdownMenuEntry(value: Text(e), label: e))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu(
                    label: const Text("Status"),
                    dropdownMenuEntries: entry,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return const Text("Loading the status...");
              }
            },
          ),
          FutureBuilder(
            future: futurePublisher,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DropdownMenuEntry> entry = snapshot.data!.filters
                    .map((e) => DropdownMenuEntry(value: Text(e), label: e))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownMenu(
                    label: const Text("Publisher"),
                    dropdownMenuEntries: entry,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return const Text("Loading the publisher...");
              }
            },
          ),
        ],
      ),
    );
  }
}
