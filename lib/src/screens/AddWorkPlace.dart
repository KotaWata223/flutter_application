import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dtp;
import 'package:cloud_firestore/cloud_firestore.dart';

class Addworkplace extends StatefulWidget{
  @override
 _WorkPlaceAddPageState createState() => _WorkPlaceAddPageState();
}

class _WorkPlaceAddPageState extends State<Addworkplace>{
final TextEditingController _titleContentController = TextEditingController();
  final TextEditingController _memoContentController = TextEditingController();

  final CollectionReference _shifts = FirebaseFirestore.instance.collection('shifts');

  String? _title;
  String? _memo;
  String? _genre;
  String? _address;
  DateTime? _deadline;
  DateTime? _payday;
  String? _salary;

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
              onChanged: (val) => _title = val,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleContentController,
              decoration: const InputDecoration(labelText: 'タイトル（任意）'),
            ),
            const SizedBox(height: 20),
            Text('ジャンル',style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            DropdownButtonMenu(),

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
                

                await _shifts.add({
                  'title': _title,
                  
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

class DropdownButtonMenu extends StatefulWidget{
  const DropdownButtonMenu({Key? key}) : super(key: key);

  @override
  State<DropdownButtonMenu> createState() => _DropdownButtonMenustate();
}

class _DropdownButtonMenustate extends State<DropdownButtonMenu>{
  String isSelectedValue = '居酒屋・カフェ・他飲食店';

  @override
  Widget build(BuildContext context){
    return DropdownButton(
      items: const[
        DropdownMenuItem(value:'居酒屋・カフェ・他飲食店',child: Text('居酒屋・カフェ・他飲食店'),
        ),
        DropdownMenuItem(value:'スーパー・コンビニ',child: Text('スーパー・コンビニ'),
        ),
        DropdownMenuItem(value:'アパレル',child: Text('アパレル'),
        ),
        DropdownMenuItem(value:'家電・雑貨・他販売',child: Text('家電・雑貨・他販売'),
        ),
        DropdownMenuItem(value:'カラオケ・パチンコ・他レジャー施設',child: Text('カラオケ・パチンコ・他レジャー施設'),
        ),
        DropdownMenuItem(value:'フロント・受付窓口・他サービス',child: Text('フロント・受付窓口・他サービス'),
        ),
        DropdownMenuItem(value:'事務・オフィスワーク',child: Text('事務・オフィスワーク'),
        ),
      ], 
      value: isSelectedValue,
      onChanged:(String? value){
        setState(() {
          isSelectedValue = value!;
        });
      } 
      );
  }
}