import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/bar_graph.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => SizedBox(
        height: 2000,
        child: MyBarGraph(
            maxY: 1000,
            sunAmount: 100,
            monAmount: 500,
            tueAmount: 250,
            wedAmount: 230,
            thuAmount: 1050,
            friAmount: 1500,
            satAmount: 750),
      ),
    );
  }
}
