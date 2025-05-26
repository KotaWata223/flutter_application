import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import 'screens/PayrollPage.dart';
import 'screens/MyPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Flutter公式サイトThemeを設定
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // NavigationBarのClassを呼び出す
      home: const BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // 各画面のリスト
  static const _screens = [
    HomePage(),
    PayrollPage(),
    MyPage()
  ];
  // 選択されている画面のインデックス
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: _screens[_selectedIndex],
      // 本題のNavigationBar
      bottomNavigationBar: NavigationBar(
        // タップされたタブのインデックスを設定（タブ毎に画面の切り替えをする）
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // 選択されているタブの色（公式サイトのまま黄色）
        indicatorColor: Colors.green,
        // 選択されたタブの設定（設定しないと画面は切り替わってもタブの色は変わらないです）
        selectedIndex: _selectedIndex,
        // タブ自体の設定（必須項目のため、書かないとエラーになります）
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month),
            label: 'シフト',
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_yen),
            label: '給料計算',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
        ],
      )
    );
  }
}
