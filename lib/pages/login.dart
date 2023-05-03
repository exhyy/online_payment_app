import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_payment_app/pages/home.dart';
import 'package:online_payment_app/pages/register.dart';
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

  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
  }

  Future<void> login() async {
    Response response = await dio.post('/user/authenticate', data: {
      'mobileNumber': mobileNumberController.text,
      'password': passwordController.text
    });
    if (response.data.toString() == 'pass' && mounted) {
      showToast(_fToast, '登录成功', ToastType.success);
      // 跳转到Home并且不允许返回
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Home(
                    mobileNumber: mobileNumberController.text,
                  )),
          (route) => false);
    } else {
      showToast(_fToast, '手机号码或密码错误', ToastType.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
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
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
              ),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => const Register(),
                      ))
                      .then(
                        (value) => _fToast.init(context),
                      );
                },
                child: const Text(
                  '注册账号',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
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
      ),
    );
  }
}
