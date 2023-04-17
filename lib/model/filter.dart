import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/dio_client.dart';

class Filters extends ChangeNotifier {
  List<String> type = [];
  List<String> status = [];
  List<String> publisher = [];


  final BaseClient _client = BaseClient();

  Future<void> fetchFilters() async {
    await _client.setupCookieForRequest();
    final res1 = await _client.dio.get('/api/filter/type');
    final res2 = await _client.dio.get('/api/filter/status');
    final res3 = await _client.dio.get('/api/filter/publisher');


    type = (res1.data as List).map((item) => item as String).toList();
    status = (res2.data as List).map((item) => item as String).toList();
    publisher = (res3.data as List).map((item) => item as String).toList();

    notifyListeners();
  }
}
