import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => const Home(),
    },
  ));
}
