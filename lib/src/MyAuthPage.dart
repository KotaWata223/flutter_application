import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/src/screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  String newUserEmail = "";
  String newUserPassword = "";
  String confirmPassword = "";
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 239),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "新規ユーザー登録",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード（6文字以上）"),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード再入力"),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    final auth = FirebaseAuth.instance;
                    final result = await auth.createUserWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );

                    final user = result.user!;
                    setState(() {
                      infoText = "登録OK：${user.email}";
                    });

                    // ✅ 登録完了後にHomePageに遷移
                   Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      infoText = "登録NG：${e.message}";
                    });
                  }
                },
                child: Text("ユーザー登録", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              Text(
                infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
