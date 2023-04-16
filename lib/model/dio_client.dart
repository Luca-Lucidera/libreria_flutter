import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class BaseClient {
  static final BaseClient client = BaseClient._init();

  Dio dio = Dio();

  factory BaseClient() {
    return client;
  }

  BaseClient._init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://mia-libreria.vercel.app'
      )
    );
  }

  Future<void> setupCookieForRequest() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
    await jar.loadForRequest(Uri.parse('https://mia-libreria.vercel.app'));
  }
}