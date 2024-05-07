import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/bar_graph.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/date_time/date_time_helper.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  // calculate max amount in bar graph
  double calculateMaxAmount(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double? max = 100;
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    //sort from smallest to largest
    values.sort();

    // get largest amount
    // and increase the cap slighltly so the graph looks almost full
    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  // calculate the week total
  String calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double total = 0;
    total += value.calculateDailyExpenseSummary()[sunday] ?? 0;
    total += value.calculateDailyExpenseSummary()[monday] ?? 0;
    total += value.calculateDailyExpenseSummary()[tuesday] ?? 0;
    total += value.calculateDailyExpenseSummary()[wednesday] ?? 0;
    total += value.calculateDailyExpenseSummary()[thursday] ?? 0;
    total += value.calculateDailyExpenseSummary()[friday] ?? 0;
    total += value.calculateDailyExpenseSummary()[saturday] ?? 0;

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of this week
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tueday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wedday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thuday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String satday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          // week total
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, bottom: 5.0, top: 25.0),
            child: Row(
              children: [
                const Text('Week Total: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '\Rs${calculateWeekTotal(value, sunday, monday, tueday, wedday, thuday, friday, satday)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Today's daily expense
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, bottom: 25.0, top: 5.0),
            child: Row(
              children: [
                const Text('Today\'s Total: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '\Rs${value.calculateDailyExpenseSummary()[convertDateTimeToString(DateTime.now())] ?? 0}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          SizedBox(
            height: 200,
            child: MyBarGraph(
                maxY: calculateMaxAmount(value, sunday, monday, tueday, wedday,
                    thuday, friday, satday),
                sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                tueAmount: value.calculateDailyExpenseSummary()[tueday] ?? 0,
                wedAmount: value.calculateDailyExpenseSummary()[wedday] ?? 0,
                thuAmount: value.calculateDailyExpenseSummary()[thuday] ?? 0,
                friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                satAmount: value.calculateDailyExpenseSummary()[satday] ?? 0),
          ),
        ],
      ),
    );
  }
}
