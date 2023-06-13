import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_payment_app/services/common.dart' show configureDio;

void main() {
  configureDio();
  runApp(MaterialApp(
    builder: FToastBuilder(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => const Login(),
    },
  ));
}
