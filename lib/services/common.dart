import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:online_payment_app/env/env.dart';
import 'package:fluttertoast/fluttertoast.dart';

final dio = Dio();

void configureDio() {
  dio.options.baseUrl = Env.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
}

enum ToastType {
  success,
  fail,
}

void showToast(FToast fToast, String text, ToastType type) {
  late Color backgroundColor;
  late Color color;
  late Icon icon;
  if (type == ToastType.success) {
    backgroundColor = Colors.greenAccent;
    color = Colors.black;
    icon = Icon(
      Icons.check,
      color: color,
    );
  } else if (type == ToastType.fail) {
    backgroundColor = Colors.redAccent;
    color = Colors.white;
    icon = Icon(
      Icons.close,
      color: color,
    );
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(
          width: 12.0,
        ),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
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
        splashRadius: 25,
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
