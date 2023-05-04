import 'package:flutter/material.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:dio/dio.dart' show Response;

class PaymentList extends StatefulWidget {
  const PaymentList({super.key, required this.accountId});

  final int accountId;

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  List<Map> allPayments = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    Response response = await dio.post('/account/payment/preview',
        data: {'accountId': widget.accountId});
    allPayments = response.data['data'].cast<Map>();
    allPayments.sort((a, b) => a['time'].compareTo(b['time']));
    allPayments = allPayments.reversed.toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '交易',
      body: BaseCard(
        child: SizedBox(
          height: double.infinity,
          child: ListView.separated(
            itemCount: allPayments.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 2.0, color: Color.fromRGBO(0, 0, 0, 0.6)),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                leading: Text(
                  allPayments[index]['name'],
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
                title: Text(
                  allPayments[index]['time'].toString().substring(0, 10),
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
                trailing: Text(
                  '-￥${allPayments[index]['amount'].toString()}',
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
