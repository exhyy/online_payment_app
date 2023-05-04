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
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    _fToast.init(context);
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
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1940),
                          lastDate: DateTime.now(),
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
                    showToast(_fToast, '信息不完整', ToastType.fail);
                  } else {
                    Response response =
                        await dio.post('/account/info/edit', data: {
                      'accountId': widget.accountId,
                      'name': _nameController.text,
                      'gender': _gender,
                      'birthday': _birthday,
                    });
                    if (response.data['errCode'] == 0) {
                      showToast(_fToast, '修改成功', ToastType.success);
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
