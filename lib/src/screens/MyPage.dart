import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('マイページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // プロフィール画像
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'), // 画像を追加
            ),
            SizedBox(height: 10),
            Text('田村コウタ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('kota@example.com', style: TextStyle(fontSize: 16, color: Colors.grey)),

            SizedBox(height: 20),

            // 設定メニュー
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('パスワード変更'),
                    onTap: () {
                      // パスワード変更画面へ
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('通知設定'),
                    onTap: () {
                      // 通知設定画面へ
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('ログアウト'),
                    onTap: () {
                      // ログアウト処理
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}