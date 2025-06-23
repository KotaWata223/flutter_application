import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/src/screens/AddWorkPlace.dart';
import 'package:flutter_application_2/src/screens/ChangePass.dart';

FirebaseAuth auth = FirebaseAuth.instance;
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
     User? user = FirebaseAuth.instance.currentUser;
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
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 10),
             Text(
              user?.email ?? 'メールアドレス未取得',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // 設定メニュー
            Flexible(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('勤務先登録'),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Addworkplace()),
                        );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('パスワード変更'),
                    onTap: () {
                      // パスワード変更画面へ
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('通知設定'),
                    onTap: () {
                      // 通知設定画面へ
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('ログアウト'),
                    onTap: () {
                      openLogOutDialog(context);
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

  void openLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('ログアウト'),
          content: const Text('ログアウトしますか?'),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'キャンセル',
                style: TextStyle(color: Colors.blueAccent),
              ),
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text(
                'ログアウト',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                logout(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  

 void logout(BuildContext context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  } catch (e) {
    print('ログアウトエラー: $e');
  }
}

}