import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dtp;

class ShiftInputPage extends StatefulWidget {
  @override
  _ShiftInputPageState createState() => _ShiftInputPageState();
}

class _ShiftInputPageState extends State<ShiftInputPage> {
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
            Text('勤務先: ツルハドラッグ常葉店'),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'タイトル（任意）'),
              onChanged: (val) => _title = val,
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(_startDateTime == null
                  ? '開始日時を選択'
                  : '開始: ${_startDateTime.toString()}'),
              trailing: const Icon(Icons.access_time),
              onTap: () {
                dtp.DatePicker.showDateTimePicker(context,
                  locale: dtp.LocaleType.jp,
                  showTitleActions: true,
                  currentTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() => _startDateTime = date);
                  });
              },
            ),
            ListTile(
              title: Text(_endDateTime == null
                  ? '終了日時を選択'
                  : '終了: ${_endDateTime.toString()}'),
              trailing: const Icon(Icons.access_time),
              onTap: () {
                dtp.DatePicker.showDateTimePicker(context,
                  locale: dtp.LocaleType.jp,
                  showTitleActions: true,
                  currentTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() => _endDateTime = date);
                  });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'メモ'),
              maxLines: 3,
              onChanged: (val) => _memo = val,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // 保存処理など
                print('保存: $_startDateTime - $_endDateTime\nタイトル: $_title\nメモ: $_memo');
              },
              child: const Text('完了する'),
            ),
          ],
        ),
      ),
    );
  }
}