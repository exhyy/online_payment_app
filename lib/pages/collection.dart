import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dio/dio.dart' show Response;

class Collection extends StatefulWidget {
  const Collection({super.key, required this.accountId});

  final int accountId;

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  int tempPaymentToken = DateTime.now().millisecondsSinceEpoch;
  String tempPaymentKey = '';
  QrImageView? qrImage;
  bool tempPaymentCreated = false;
  bool timerStop = true;

  @override
  void initState() {
    super.initState();
    tempPaymentToken = DateTime.now().millisecondsSinceEpoch;
    _getData();
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (tempPaymentCreated) {
        Response response = await dio.post('/account/payment/temp/renewal',
            data: {'accountId': widget.accountId, 'token': tempPaymentToken});
        if (response.data['errCode'] != 0 || timerStop) {
          timerStop = true;
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timerStop = true;
    super.dispose();
  }

  void _getData() async {
    Response response = await dio.post('/account/payment/temp/create',
        data: {'accountId': widget.accountId, 'token': tempPaymentToken});
    if (response.data['errCode'] == 0) {
      tempPaymentKey = response.data['data'];
      qrImage = QrImageView(
        data: tempPaymentKey,
        version: QrVersions.auto,
        size: 250.0,
      );
      tempPaymentCreated = true;
      timerStop = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '收款',
      body: Center(
        child: qrImage,
      ),
    );
  }
}
