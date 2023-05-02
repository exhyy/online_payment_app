import 'package:flutter/material.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' show Response;

class InfomationModify extends StatefulWidget {
  const InfomationModify({super.key, required this.accountId});

  final int accountId;

  @override
  State<InfomationModify> createState() => _InfomationModifyState();
}

class _InfomationModifyState extends State<InfomationModify> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = 'unknown';
  String _birthday = '请选择日期';
  late FToast _fToast;

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
  }

  void _showToast(Text text, bool success) {
    Color color = Colors.greenAccent;
    Icon icon = const Icon(Icons.check);
    if (success == false) {
      color = Colors.redAccent;
    }
    if (success == false) {
      icon = const Icon(Icons.close);
    }

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 12.0,
          ),
          text,
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '修改信息',
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
                      '姓名',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      '性别',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: DropdownButton(
                      value: _gender,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(
                            '男',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(
                            '女',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'unknown',
                          child: Text(
                            '保密',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _gender = value;
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Text(
                      '生日',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    title: TextButton(
                      onPressed: () async {
                        DateTime? datePicked =
                            await DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1940),
                          lastDate: DateTime(2023),
                          dateFormat: 'yyyy-MMMM-dd',
                          locale: DateTimePickerLocale.zh_cn,
                          looping: false,
                          titleText: '选择生日',
                          confirmText: '确定',
                          cancelText: '取消',
                        );
                        if (datePicked != null) {
                          setState(() {
                            _birthday = datePicked.toString().substring(0, 10);
                          });
                        }
                      },
                      child: Text(
                        _birthday,
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
                  if (_nameController.text == '' || _birthday == '请选择日期') {
                    _showToast(const Text('信息不完整'), false);
                  } else {
                    Response response =
                        await dio.post('/account/info/edit', data: {
                      'accountId': widget.accountId,
                      'name': _nameController.text,
                      'gender': _gender,
                      'birthday': _birthday,
                    });
                    if (response.statusCode == 200) {
                      _showToast(const Text('修改成功'), true);
                    } else {
                      _showToast(const Text('修改失败'), false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text(
                    '提交',
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
