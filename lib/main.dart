import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/home.dart';
import 'package:online_payment_app/pages/login.dart';
import 'package:online_payment_app/pages/payment_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
    builder: FToastBuilder(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/login': (context) => const Login(),
      '/home': (context) => const Home(mobileNumber: '12345678909'),
      '/payment_list': (context) => const PaymentList(accountId: 1),
    },
  ));
}
