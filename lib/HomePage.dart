import 'package:flutter/material.dart';
import 'package:flutter_application_2/FirstPage.dart';
import 'package:flutter_application_2/SecondPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
    children: [
      OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FirstPage(),
            ),
          );
        },
        child: const Text('ログイン'),
      ),
      const SizedBox(height: 20), // ボタン間のスペース
      OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  SecondPage(),
            ),
          );
        },
        child: const Text('新規登録'),
      ),
    ],
  ),
),

    );
  }
}


