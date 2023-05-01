import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:online_payment_app/env/env.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final dio = Dio();

  void configureDio() {
    dio.options.baseUrl = Env.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  void login() async {
    Response response = await dio.post('/user/authenticate', data: {
      'mobileNumber': mobileNumberController.text,
      'password': passwordController.text
    });
    print(response.data.toString());
  }

  @override
  Widget build(BuildContext context) {
    configureDio();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '在线支付APP',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextField(
            controller: mobileNumberController,
            cursorHeight: 30,
            decoration: const InputDecoration(
              labelText: '手机号码',
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '密码',
            ),
          ),
          MaterialButton(
            child: Text(
              '登录',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: login,
          ),
        ],
      ),
    );
  }
}
