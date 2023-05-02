import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:online_payment_app/env/env.dart';

final dio = Dio();

void configureDio() {
  dio.options.baseUrl = Env.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
}

class BaseCard extends StatelessWidget {
  final Widget child;

  const BaseCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      width: double.infinity,
      child: child,
    );
  }
}

class MyScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? appBarAction;
  const MyScaffold(
      {super.key, required this.title, required this.body, this.appBarAction});

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    if (Navigator.of(context).canPop()) {
      leading = IconButton(
        icon: const Icon(Icons.chevron_left),
        iconSize: 45,
        color: const Color.fromRGBO(160, 160, 160, 1.0),
        onPressed: () => Navigator.of(context).pop(),
      );
    }
    List<Widget>? actions = [];
    if (appBarAction != null) {
      actions.add(appBarAction!);
    } else {
      actions = null;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1.0),
      appBar: AppBar(
        leading: leading,
        actions: actions,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1.0),
      ),
      body: body,
    );
  }
}
