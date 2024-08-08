import 'package:flutter/material.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/date_time/date_time_helper.dart';
import 'package:provider/provider.dart';

class BalanceCard extends StatefulWidget {
  BalanceCard({super.key, required this.month1, required this.month2});

  DateTime month1;
  DateTime month2;

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  late String month1Name;
  late String month2Name;

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  @override
  Widget build(BuildContext context) {
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    // Initialize the month names
    month1Name = monthNames[widget.month1.month - 1];
    month2Name = monthNames[widget.month2.month - 1];

    return Consumer<ExpenseData>(
      builder: (context, expenseData, child) {
        double month1total =
            expenseData.calculateMonthlyTotalExpense(widget.month1);
        double month2total =
            expenseData.calculateMonthlyTotalExpense(widget.month2);

        Icon arrow;
        double difference;

        if (month1total > month2total) {
          difference = month1total - month2total;
          arrow = const Icon(
            Icons.arrow_downward,
            color: Colors.green,
          );
        } else {
          difference = month2total - month1total;
          arrow = const Icon(Icons.arrow_upward, color: Colors.red);
        }

        return Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '$month1Name Total',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '\Rs. $month1total',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '$month2Name Total',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '\Rs. $month2total',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(child: arrow),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '\Rs. $difference',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
