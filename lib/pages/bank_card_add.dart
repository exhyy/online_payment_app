import 'package:flutter/material.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' show Response;

class BankCardAdd extends StatefulWidget {
  const BankCardAdd({super.key, required this.accountId});

  final int accountId;

  @override
  State<BankCardAdd> createState() => _BankCardAddState();
}

class _BankCardAddState extends State<BankCardAdd> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  String _cardType = 'Credit Card';
  String _expirationDate = '请选择日期';
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '添加银行卡',
      body: BaseCard(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 120),
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ListTile(
                    leading: const Text(
                      '银行',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: TextField(
                      controller: _bankNameController,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      '卡号',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: TextField(
                      controller: _cardNumberController,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      '类型',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: DropdownButton(
                      value: _cardType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'Credit Card',
                          child: Text(
                            '信用卡',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Debit Card',
                          child: Text(
                            '借记卡',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _cardType = value;
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      '到期时间',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: TextButton(
                      onPressed: () async {
                        DateTime? datePicked =
                            await DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime(2022),
                          firstDate: DateTime(1940),
                          lastDate: DateTime(2050, 12, 31),
                          dateFormat: 'yyyy-MMMM-dd',
                          locale: DateTimePickerLocale.zh_cn,
                          looping: false,
                          titleText: '选择到期时间',
                          confirmText: '确定',
                          cancelText: '取消',
                        );
                        if (datePicked != null) {
                          setState(() {
                            _expirationDate = datePicked.toString().substring(0, 10);
                          });
                        }
                      },
                      child: Text(
                        _expirationDate,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_bankNameController.text == '' || _cardNumberController.text == '' || _expirationDate == '请选择日期') {
                    showToast(_fToast, '信息不完整', ToastType.fail);
                  } else {
                    Response response =
                        await dio.post('/account/bankcard/add', data: {
                      'accountId': widget.accountId,
                      'bankName': _bankNameController.text,
                      'number': _cardNumberController.text,
                      'type': _cardType,
                      'expirationDate': _expirationDate,
                    });
                    if (response.data['errCode'] == 0) {
                      showToast(_fToast, '添加成功', ToastType.success);
                    } else if (response.data['errCode'] == 1) {
                      showToast(_fToast, '该银行卡已存在', ToastType.fail);
                    } else {
                      showToast(_fToast, '未知错误', ToastType.fail);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text(
                    '添加',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
