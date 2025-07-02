import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtp;
import 'package:cloud_firestore/cloud_firestore.dart';

class Addworkplace extends StatefulWidget {
  @override
  _WorkPlaceAddPageState createState() => _WorkPlaceAddPageState();
}

class _WorkPlaceAddPageState extends State<Addworkplace> {
  final TextEditingController _memoContentController = TextEditingController();
  final CollectionReference _workplaces =
      FirebaseFirestore.instance.collection('workplace');

  String? _place;
  String? _address;
  String? _genre = '居酒屋・カフェ・他飲食店'; // 初期値
  int? _deadlineDay;
  int? _paydayDay;
  String? _salary;
  String? _memo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('勤務先の追加')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: '勤務先（必須）'),
              onChanged: (val) => _place = val,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: '住所'),
              onChanged: (val) => _address = val,
            ),
            const SizedBox(height: 10),
            Text('ジャンル', style: TextStyle(fontSize: 16, color: Colors.grey)),
            DropdownButtonMenu(
              initialValue: _genre!,
              onChanged: (value) => setState(() => _genre = value),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: '給料（例：時給1100円）'),
              onChanged: (val) => _salary = val,
            ),
            const SizedBox(height: 20),
            // 締日選択
            Text('締日', style: TextStyle(fontSize: 16, color: Colors.grey)),
            DropdownButton<int>(
              value: _deadlineDay,
              hint: Text('締日を選択'),
              isExpanded: true,
              items: List.generate(31, (index) => index + 1).map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text('$day日'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _deadlineDay = value;
                });
              },
            ),
            const SizedBox(height: 20),

// 給料日選択
            Text('給料日', style: TextStyle(fontSize: 16, color: Colors.grey)),
            DropdownButton<int>(
              value: _paydayDay,
              hint: Text('給料日を選択'),
              isExpanded: true,
              items: List.generate(31, (index) => index + 1).map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text('$day日'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _paydayDay = value;
                });
              },
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            TextField(
              controller: _memoContentController,
              decoration: const InputDecoration(labelText: 'メモ'),
              maxLines: 3,
              onChanged: (val) => _memo = val,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('勤務先を追加'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (_place == null || _place!.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('勤務先は必須項目です')),
                  );
                  return;
                }

                await _workplaces.add({
                  'place': _place,
                  'address': _address ?? '',
                  'genre': _genre ?? '',
                  'salary': _salary ?? '',
                  '締日': _deadlineDay ?? '',
                  '給料日': _paydayDay ?? '',
                  'memo': _memo ?? '',
                  'createdAt': Timestamp.now(),
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonMenu extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const DropdownButtonMenu({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownButtonMenu> createState() => _DropdownButtonMenuState();
}

class _DropdownButtonMenuState extends State<DropdownButtonMenu> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      isExpanded: true,
      items: const [
        DropdownMenuItem(value: '居酒屋・カフェ・他飲食店', child: Text('居酒屋・カフェ・他飲食店')),
        DropdownMenuItem(value: 'スーパー・コンビニ', child: Text('スーパー・コンビニ')),
        DropdownMenuItem(value: 'アパレル', child: Text('アパレル')),
        DropdownMenuItem(value: '家電・雑貨・他販売', child: Text('家電・雑貨・他販売')),
        DropdownMenuItem(
            value: 'カラオケ・パチンコ・他レジャー施設', child: Text('カラオケ・パチンコ・他レジャー施設')),
        DropdownMenuItem(
            value: 'フロント・受付窓口・他サービス', child: Text('フロント・受付窓口・他サービス')),
        DropdownMenuItem(value: '事務・オフィスワーク', child: Text('事務・オフィスワーク')),
      ],
      onChanged: (String? value) {
        if (value != null) {
          setState(() => selectedValue = value);
          widget.onChanged(value);
        }
      },
    );
  }
}
