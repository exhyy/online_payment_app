import 'package:flutter/material.dart';

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
  const MyScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1.0),
      appBar: AppBar(
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
