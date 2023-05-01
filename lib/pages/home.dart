import 'package:flutter/material.dart';
import 'package:online_payment_app/services/common.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1.0),
      appBar: AppBar(
        title: const Text(
          '钱包',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1.0),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                HomeButton(
                  title: '付款',
                  assetPath: 'assets/icons/cash.png',
                ),
                HomeButton(
                  title: '付款',
                  assetPath: 'assets/icons/money-bag-e.png',
                )
              ],
            ),
          ),
          BaseCard(
            child: Column(
              children: const [
                HomeListTile(
                  title: '余额',
                  assetPath: 'assets/icons/yuan.png',
                  comment: '￥666.66',
                ),
                HomeListTile(
                  title: '银行卡',
                  assetPath: 'assets/icons/credit.png',
                ),
              ],
            ),
          ),
          const BaseCard(
            child: HomeListTile(
              title: '信息',
              assetPath: 'assets/icons/driver-license.png',
            ),
          ),
          BaseCard(
            child: Column(
              children: const [
                HomeListTile(
                  title: '近期交易',
                  assetPath: 'assets/icons/invoice.png',
                ),
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

  const HomeListTile({
    super.key,
    required this.title,
    required this.assetPath,
    this.comment,
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
    trailingChildren.add(const Icon(
      Icons.chevron_right,
      size: 35,
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

  const HomeButton({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: [
          Image.asset(
            assetPath,
            width: 90,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
            ),
          )
        ],
      ),
    );
  }
}
