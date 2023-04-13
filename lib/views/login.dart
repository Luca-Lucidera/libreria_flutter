import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:flutter/material.dart';
import 'package:libreria_flutter/model/user.dart';
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your library'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Login"),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "email",
                    hintText: "Enter your email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    //explain the regex
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "password",
                    hintText: "Enter your password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    //explain the regex
                    if (!RegExp(
                            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~%]).{8,}$")
                        .hasMatch(value)) {
                      return "Password must contain at least 8 characters, one uppercase, one lowercase, \n one number and one special character";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  child: const Text("Login"),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final dio = Dio();
                      final Directory appDocDir =
                          await getApplicationDocumentsDirectory();
                      final String appDocPath = appDocDir.path;
                      final jar = PersistCookieJar(
                        ignoreExpires: false,
                        storage: FileStorage("$appDocPath/.cookies/"),
                      );
                      dio.interceptors.add(CookieManager(jar));
                      try {
                        final response = await dio.post(
                          'https://mia-libreria.vercel.app/api/auth/login',
                          data: {
                            "email": emailController.text,
                            "password": passwordController.text
                          },
                        );
                        if (response.statusCode == 200 && context.mounted) {
                          User.fromJson(response.data);
                          await Navigator.of(context).pushReplacementNamed('/');
                        }
                      } on DioError catch (error) {
                        if (context.mounted) {
                          if(error.response!.statusCode != 500) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid credentials'),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Server error'),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.deepOrange,
                              ),
                            );
                          }

                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Center(
    //   child: ElevatedButton(
    //     child: const Text("Popola"),
    //     onPressed: () async {
    //       const json =
    //           '{"name":"luca", "lastName":"lucidera", "email":"luca@luca", "password": "12345678", "jwt":"ciao"}';
    //       user.fromJson(jsonDecode(json));
    //       await Navigator.of(context).pushReplacementNamed('/');
    //     },
    //   ),
    // );
  }
}
