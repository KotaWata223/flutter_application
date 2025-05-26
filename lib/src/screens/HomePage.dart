import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // サンプルイベントデータ
    _eventsList = {
      DateTime.now().subtract(const Duration(days: 2)): ['イベント A6', 'イベント B6'],
      DateTime.now(): ['イベント A7', 'イベント B7', 'イベント C7', 'イベント D7'],
      DateTime.now().add(const Duration(days: 1)): [
        'イベント A8',
        'イベント B8',
        'イベント C8',
        'イベント D8'
      ],
      DateTime.now().add(const Duration(days: 3)):
          Set.from(['イベント A9', 'イベント A9', 'イベント B9']).toList(),
      DateTime.now().add(const Duration(days: 7)): [
        'イベント A10',
        'イベント B10',
        'イベント C10'
      ],
    };
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
    return Container(
      height: 230.0,
      width: 700, //高さ
      color: const Color.fromARGB(255, 255, 246, 220), //色
      child: Text(
          ' ${selectedDay.toLocal().toString().split(' ')[0]}にシフトを追加する'), // ここで表示
    );
  }
}
