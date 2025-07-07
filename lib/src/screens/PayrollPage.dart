import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PayrollPage extends StatefulWidget {
  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends State<PayrollPage> {
  double totalSalary = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    calculateSalaryForCurrentMonth();
  }

  Future<void> calculateSalaryForCurrentMonth() async {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final shiftsSnapshot = await FirebaseFirestore.instance
        .collection('shifts')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    Map<String, double> workplaceSalaries = {};

    double total = 0.0;

    for (var doc in shiftsSnapshot.docs) {
      final data = doc.data();
      final Timestamp startTimestamp = data['startTime'];
      final Timestamp endTimestamp = data['endTime'];
      final String workplaceId = data['workplaceId'];

      if (!workplaceSalaries.containsKey(workplaceId)) {
        final workplaceDoc = await FirebaseFirestore.instance
            .collection('workplaces')
            .doc(workplaceId)
            .get();

        final salary = workplaceDoc.data()?['salary']?.toDouble() ?? 0.0;
        workplaceSalaries[workplaceId] = salary;
      }

      final salaryPerHour = workplaceSalaries[workplaceId] ?? 0.0;
      final duration = endTimestamp.toDate().difference(startTimestamp.toDate());
      final workedHours = duration.inMinutes / 60.0;

      total += workedHours * salaryPerHour;
    }

    setState(() {
      totalSalary = total;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: "ja_JP", symbol: "¥");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("今月の給料"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                "今月の給料は\n${formatter.format(totalSalary)}です",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
