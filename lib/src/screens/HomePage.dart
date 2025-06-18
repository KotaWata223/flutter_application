import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dtp;
import 'package:flutter_application_2/src/screens/AddShift.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> fetchShiftsFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('shifts').get();

  Map<DateTime, List> loadedEvents = {};

  for (var doc in snapshot.docs) {
    final data = doc.data();

    if (data.containsKey('starttime') &&
        data.containsKey('endtime') &&
        data.containsKey('title')) {
      final DateTime start = DateTime.parse(data['starttime']);
      final DateTime end = DateTime.parse(data['endtime']);
      final String title = data['title'];

      final normalizedData = DateTime(start.year, start.month, start.day);
      final eventText =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
          '〜${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')} '
          '$title';
      if (loadedEvents[normalizedData] == null) {
        loadedEvents[normalizedData] = [];
      }
      loadedEvents[normalizedData]!.add(eventText);
    }
  }
  setState(() {
    _eventsList = loadedEvents;
  });
}

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchShiftsFromFirestore(); 
    // サンプルイベントデータ
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ja_JP',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: getEventForDay,
          ),
          OutlinedButton(
            child: const Text('シフト追加'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) =>
                    _BottomSheet(selectedDay: _selectedDay ?? DateTime.now()),
              );
            },
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: getEventForDay(_selectedDay!)
                  .map((event) => ListTile(
                        title: Text(event.toString()),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class _RenderFloatingActionButton extends StatelessWidget {
  //シフト追加のボタン

  final DateTime selectedDay;

  const _RenderFloatingActionButton({required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //押したときの処理
        showModalBottomSheet(
          //関数呼び出し
          context: context,
          builder: (context) => _BottomSheet(selectedDay: selectedDay),
        );
      },
      child: Icon(Icons.add),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final DateTime selectedDay;

  const _BottomSheet({Key? key, required this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // サンプルデータ（ここは将来的に入力や保存データに置き換える）
    final sampleShiftList = [
      '09:00 - 12:00',
      '13:00 - 17:00',
      '18:00 - 21:00',
    ];

    return Container(
      height: 300.0,
      color: const Color.fromARGB(255, 199, 249, 180),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedDay.toLocal().toString().split(' ')[0]} にシフトを追加する',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: sampleShiftList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sampleShiftList[index]),
                  leading: const Icon(Icons.schedule),
                );
              },
            ),
          ),
          ElevatedButton(
            child: const Text('Button'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddShiftPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
