import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/bank_card_add.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' show Response;

class BankCard extends StatefulWidget {
  const BankCard({super.key, required this.accountId});

  final int accountId;

  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
  List<Map> bankCardInfo = [];
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
    _getData();
  }

  void _getData() async {
    Response response = await dio
        .post('/account/bankcard', data: {'accountId': widget.accountId});
    bankCardInfo = response.data.cast<Map>();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '银行卡',
      appBarAction: IconButton(
        icon: const Icon(
          Icons.add_circle_outline,
          color: Color.fromRGBO(160, 160, 160, 1.0),
        ),
        iconSize: 34,
        splashRadius: 25,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      BankCardAdd(accountId: widget.accountId)))
              .then((value) {
            _getData();
            _fToast.init(context);
          });
        },
      ),
      body: BaseCard(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: double.infinity,
          child: ListView.separated(
            itemCount: bankCardInfo.length,
            itemBuilder: (context, index) {
              String cardType = '';
              if (bankCardInfo[index]['type'] == 'Credit Card') {
                cardType = '信用卡';
              } else if (bankCardInfo[index]['type'] == 'Debit Card') {
                cardType = '借记卡';
              }

              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(214, 116, 116, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: double.infinity,
                child: Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          Response response = await dio
                              .post('/account/bankcard/delete', data: {
                            'accountId': widget.accountId,
                            'number': bankCardInfo[index]['number']
                          });
                          if (response.statusCode == 200) {
                            showToast(_fToast, '删除成功', ToastType.success);
                            _getData();
                          } else {
                            showToast(_fToast, '删除失败', ToastType.fail);
                          }
                        },
                        backgroundColor: const Color.fromRGBO(190, 48, 48, 1),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '删除',
                        flex: 2,
                      )
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bankCardInfo[index]['bankName'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 23,
                          ),
                        ),
                        Text(
                          cardType,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 225, 225, 225),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        Center(
                          child: Text(
                            bankCardInfo[index]['number'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        ),
      ),
    );
  }
}
