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
