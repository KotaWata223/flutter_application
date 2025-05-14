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
      body: const Center(
          child: Text('マイページ', style: TextStyle(fontSize: 32.0))
      ),
    );
  }

}