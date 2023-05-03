import 'package:flutter/material.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' show Response;

enum _UserType {
  individual,
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  _UserType? _userType;
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
      title: '注册账号',
      body: BaseCard(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ListTile(
                    leading: const RegisterTileLeading('手机号码'),
                    title: TextField(
                      controller: _mobileNumberController,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const RegisterTileLeading('密码'),
                    title: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const RegisterTileLeading('身份'),
                    title: DropdownButton(
                      value: _userType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: _UserType.individual,
                          child: Text(
                            '个人用户',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            '请选择',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _userType = value;
                          });
                        }
                      },
                    ),
                  ),
                  Offstage(
                    offstage: _userType != _UserType.individual,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const RegisterTileLeading('姓名'),
                          title: TextField(
                            controller: _nameController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const RegisterTileLeading('性别'),
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
                          leading: const RegisterTileLeading('生日'),
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
                                  _birthday =
                                      datePicked.toString().substring(0, 10);
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
                  ),
                ],
              ),
              Offstage(
                offstage: _userType == null,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validMobileNumber(_mobileNumberController.text) ==
                        false) {
                      showToast(_fToast, '手机号码不合法', ToastType.fail);
                    } else if (_passwordController.text.length < 8) {
                      showToast(_fToast, '密码长度不足8位', ToastType.fail);
                    } else {
                      if (_userType == _UserType.individual) {
                        if (_nameController.text == '' ||
                            _birthday == '请选择日期') {
                          showToast(_fToast, '信息不完整', ToastType.fail);
                        } else {
                          Response response =
                              await dio.post('/user/create', data: {
                            'userType': 'individual',
                            'mobileNumber': _mobileNumberController.text,
                            'password': _passwordController.text,
                            'name': _nameController.text,
                            'gender': _gender,
                            'birthday': _birthday
                          });
                          if (response.statusCode == 200) {
                            showToast(_fToast, '注册成功', ToastType.success);
                          }
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: const Text(
                      '注册',
                      style: TextStyle(
                        fontSize: 25,
                      ),
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

bool _validMobileNumber(String mobileNumber) {
  return (mobileNumber.length == 11 && double.tryParse(mobileNumber) != null);
}

class RegisterTileLeading extends StatelessWidget {
  const RegisterTileLeading(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}

class DefaultRegister extends StatelessWidget {
  const DefaultRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
