import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/home.dart';
import 'package:online_payment_app/pages/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
    builder: FToastBuilder(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/home': (context) => const Home(),
      '/login': (context) => const Login(),
    },
  ));
}
