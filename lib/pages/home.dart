import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/bank_card.dart';
import 'package:online_payment_app/pages/collection.dart';
import 'package:online_payment_app/pages/payment_scan.dart';
import 'package:online_payment_app/pages/infomation.dart';
import 'package:online_payment_app/pages/payment_list.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:dio/dio.dart' show Response;

class Home extends StatefulWidget {
  const Home({super.key, required this.mobileNumber});

  final String mobileNumber;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String balance = '';
  List<int> accountIds = [];
  List<Map> recentPayments = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    // 获取当前user所有账户id
    Response response = await dio
        .post('/account/getall', data: {'mobileNumber': widget.mobileNumber});
    accountIds = response.data['data'].cast<int>();

    // 获取首个账户id的余额
    response =
        await dio.post('/account/balance', data: {'accountId': accountIds[0]});
    balance = response.data['data'];
    balance = '￥$balance';

    // 获取“近期交易”，记录不超过3条
    response = await dio
        .post('/account/payment/preview', data: {'accountId': accountIds[0]});
    List<Map> allPayments = response.data['data'].cast<Map>();
    allPayments.sort((a, b) => a['time'].compareTo(b['time']));
    recentPayments = [];
    for (var i = allPayments.length - 1; i >= 0; i--) {
      recentPayments.add(allPayments[i]);
      if (i <= allPayments.length - 3) {
        break;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '钱包',
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HomeButton(
                  title: '付款',
                  assetPath: 'assets/icons/cash.png',
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => PaymentScan(
                            accountId: accountIds[0],
                          ),
                        ))
                        .then((value) => _getData());
                  },
                ),
                HomeButton(
                  title: '收款',
                  assetPath: 'assets/icons/money-bag-e.png',
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => Collection(
                            accountId: accountIds[0],
                          ),
                        ))
                        .then((value) => _getData());
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          BaseCard(
            child: Column(
              children: [
                HomeListTile(
                  title: '余额',
                  assetPath: 'assets/icons/yuan.png',
                  comment: balance,
                  onPressed: null,
                ),
                HomeListTile(
                  title: '银行卡',
                  assetPath: 'assets/icons/credit.png',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BankCard(accountId: accountIds[0]),
                    ));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          BaseCard(
            child: HomeListTile(
              title: '信息',
              assetPath: 'assets/icons/driver-license.png',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Infomation(accountId: accountIds[0])));
              },
            ),
          ),
          const SizedBox(height: 15),
          BaseCard(
            child: Column(
              children: [
                HomeListTile(
                  title: '近期交易',
                  assetPath: 'assets/icons/invoice.png',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PaymentList(accountId: accountIds[0])));
                  },
                ),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    itemCount: recentPayments.length,
                    separatorBuilder: (context, index) => const Divider(
                        height: 2.0, color: Color.fromRGBO(0, 0, 0, 0.6)),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
                        leading: Text(
                          recentPayments[index]['name'],
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        title: Text(
                          recentPayments[index]['time']
                              .toString()
                              .substring(0, 10),
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        trailing: Text(
                          '${recentPayments[index]['symbol'].toString()}￥${recentPayments[index]['amount'].toString()}',
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  final String assetPath;
  final String title;
  final String? comment;
  final void Function()? onPressed;

  const HomeListTile({
    super.key,
    required this.title,
    required this.assetPath,
    this.comment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> trailingChildren = [];
    if (comment != null) {
      trailingChildren.add(Text(
        comment!,
        style: const TextStyle(
          fontSize: 26,
        ),
      ));
    }
    trailingChildren.add(IconButton(
      icon: const Icon(Icons.chevron_right),
      iconSize: 35,
      splashRadius: 0.00001,
      onPressed: onPressed,
    ));

    return ListTile(
      leading: Image.asset(
        assetPath,
        width: 40,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
        ),
      ),
      trailing: SizedBox(
        width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: trailingChildren,
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String assetPath;
  final String title;
  final void Function()? onPressed;

  const HomeButton({
    super.key,
    required this.assetPath,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Image.asset(
              assetPath,
              width: 85,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
              ),
            )
          ],
        ),
      ),
    );
  }
}
