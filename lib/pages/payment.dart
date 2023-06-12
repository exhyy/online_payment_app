import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' show Response;

class Payment extends StatefulWidget {
  const Payment(
      {super.key, required this.accountId, required this.tempPaymentKey});

  final int accountId;
  final String tempPaymentKey;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _amountController = TextEditingController();
  String _payeeName = '';
  int _payeeAccondId = -1;
  bool _gotData = false;
  bool _timerStop = true;
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _getData();
    _fToast.init(context);
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_gotData) {
        Response response = await dio.post('/account/payment/temp/lock/renewal',
            data: {
              'tempPaymentKey': widget.tempPaymentKey,
              'lockerId': widget.accountId
            });
        if (response.data['errCode'] != 0 || _timerStop) {
          _timerStop = true;
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _timerStop = true;
    super.dispose();
  }

  void _getData() async {
    Response response = await dio.post('/account/payment/temp/getpayee', data: {
      'tempPaymentKey': widget.tempPaymentKey,
      'payerAccountId': widget.accountId,
    });
    if (response.data['errCode'] == 0) {
      _payeeName = response.data['data']['name'];
      _payeeAccondId = response.data['data']['accountId'];
    }
    _gotData = true;
    _timerStop = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MyScaffold(
      title: '支付',
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 140.0,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '付款给',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  _payeeName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height - 235,
            child: BaseCard(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '金额',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Text(
                              '￥',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 45,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        Response response =
                            await dio.post('/account/payment/create', data: {
                          'tempPaymentKey': widget.tempPaymentKey,
                          'payerAccountId': widget.accountId,
                          'payeeAccountId': _payeeAccondId,
                          'amount': _amountController.text,
                          'method': 'QR Code'
                        });
                        if (response.data['errCode'] == 0) {
                          showToast(_fToast, '支付成功', ToastType.success);
                        } else if (response.data['errCode'] == 1) {
                          showToast(_fToast, '对方取消交易', ToastType.fail);
                        } else if (response.data['errCode'] == 2) {
                          showToast(_fToast, '交易权限错误', ToastType.fail);
                        } else {
                          showToast(_fToast, '未知错误', ToastType.fail);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        child: const Text(
                          '支付',
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
