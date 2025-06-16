import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dtp;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddShiftPage extends StatefulWidget {
  @override
  _ShiftInputPageState createState() => _ShiftInputPageState();
}

class _ShiftInputPageState extends State<AddShiftPage> {
  final TextEditingController _titleContentController = TextEditingController();
  final TextEditingController _memoContentController = TextEditingController();

  final CollectionReference _shifts = FirebaseFirestore.instance.collection('shifts');

  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String? _title;
  String? _memo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('シフトの追加')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: '勤務先（必須）'),
              onChanged: (val) => _title = val,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleContentController,
              decoration: const InputDecoration(labelText: 'タイトル（任意）'),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(_startDateTime == null
                  ? '開始日時を選択'
                  : '開始: ${_startDateTime.toString().substring(0, 16)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () {
                dtp.DatePicker.showDateTimePicker(
                  context,
                  locale: dtp.LocaleType.jp,
                  showTitleActions: true,
                  currentTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() => _startDateTime = date);
                  },
                );
              },
            ),
            ListTile(
              title: Text(_endDateTime == null
                  ? '終了日時を選択'
                  : '終了: ${_endDateTime.toString().substring(0, 16)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () {
                dtp.DatePicker.showDateTimePicker(
                  context,
                  locale: dtp.LocaleType.jp,
                  showTitleActions: true,
                  currentTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() => _endDateTime = date);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _memoContentController,
              decoration: const InputDecoration(labelText: 'メモ'),
              maxLines: 3,
              onChanged: (val) => _memo = val,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('シフトを追加'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (_startDateTime == null || _endDateTime == null || _title == null || _title!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('勤務先・開始・終了の入力は必須です')),
                  );
                  return;
                }

                await _shifts.add({
                  'title': _title,
                  'starttime': _startDateTime!.toIso8601String().substring(0, 16),
                  'endtime': _endDateTime!.toIso8601String().substring(0, 16),
                  'memo': _memo ?? '',
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
