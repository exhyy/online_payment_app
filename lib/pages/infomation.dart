import 'package:flutter/material.dart';
import 'package:online_payment_app/pages/infomation_modify.dart';
import 'package:online_payment_app/services/common.dart';
import 'package:dio/dio.dart' show Response;

class Infomation extends StatefulWidget {
  const Infomation({super.key, required this.accountId});

  final int accountId;

  @override
  State<Infomation> createState() => _InfomationState();
}

class _InfomationState extends State<Infomation> {
  List<Map> info = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    Response response =
        await dio.post('/account/info', data: {'accountId': widget.accountId});
    info = response.data['data'].cast<Map>();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '信息',
      body: BaseCard(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 120),
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 350,
                child: ListView.builder(
                  itemCount: info.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                        width: 110,
                        child: Text(
                          '${info[index]['title']}',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Color.fromRGBO(138, 138, 138, 1),
                          ),
                        ),
                      ),
                      title: Text(
                        '${info[index]['content']}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              InfomationModify(accountId: widget.accountId)))
                      .then((value) => _getData());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text(
                    '修改信息',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
