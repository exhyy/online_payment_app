import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_payment_app/pages/home.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:dio/dio.dart' show Response;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast(bool success) {
    Color color = Colors.greenAccent;
    Icon icon = const Icon(Icons.check);
    Text text = const Text('登录成功');
    if (success == false) {
      color = Colors.redAccent;
    }
    if (success == false) {
      icon = const Icon(Icons.close);
    }
    if (success == false) {
      text = const Text('手机号码或密码错误');
    }

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 12.0,
          ),
          text,
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  Future<void> login() async {
    Response response = await dio.post('/user/authenticate', data: {
      'mobileNumber': mobileNumberController.text,
      'password': passwordController.text
    });
    if (response.data.toString() == 'pass' && mounted) {
      _showToast(true);
      // 跳转到Home并且不允许返回
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Home(
                    mobileNumber: mobileNumberController.text,
                  )),
          (route) => false);
    } else {
      _showToast(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              '在线支付APP',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 30),
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
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: login,
            child: const Text(
              '登录',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
