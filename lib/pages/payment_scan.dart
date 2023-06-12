import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_payment_app/pages/payment.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dio/dio.dart' show Response;

class PaymentScan extends StatefulWidget {
  const PaymentScan({super.key, required this.accountId});

  final int accountId;

  @override
  State<PaymentScan> createState() => _PaymentScanState();
}

class _PaymentScanState extends State<PaymentScan> {
  String? tempPaymentKey = '';
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
  }

  void _nagivateToPayment() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Payment(
            accountId: widget.accountId, tempPaymentKey: tempPaymentKey!)));
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '付款',
      body: MobileScanner(
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          if (tempPaymentKey != barcodes[0].rawValue) {
            tempPaymentKey = barcodes[0].rawValue;
            Response response = await dio.post('/account/payment/temp/lock',
                data: {
                  'tempPaymentKey': tempPaymentKey,
                  'lockerId': widget.accountId
                });
            if (response.data['errCode'] == 0) {
              showToast(_fToast, '扫码成功', ToastType.success);
              _nagivateToPayment();
            } else if (response.data['errCode'] == 1) {
              showToast(_fToast, '交易不存在', ToastType.fail);
            } else if (response.data['errCode'] == 2) {
              showToast(_fToast, '交易进行中', ToastType.fail);
            }
          }
        },
      ),
    );
  }
}
