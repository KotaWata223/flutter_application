import 'package:flutter/material.dart';

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('給料計算'),
      ),
      body: const Center(
          child: Text('給与計算ページ', style: TextStyle(fontSize: 32.0))
      ),
    );
  }

}