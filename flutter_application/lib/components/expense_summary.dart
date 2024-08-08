import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/bar_graph.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/date_time/date_time_helper.dart';
import 'package:flutter_application/pages/comparison_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/bar_graph/category_graph.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    max = values.last * 1.4;

    return max == 0 ? 100 : max;
  }

  // double calculateMonthTotalByCategory(
  //     ExpenseData value, String month, String category) {
  //   double total = 0;
  //   for (var expense in value.getAllExpenseList()) {
  //     if (expense.date.substring(0, 7) == month &&
  //         expense.category == category) {
  //       total += expense.amount;
  //     }
  //   }
  //   return total;
  // }

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
    final PageController _pageController = PageController();
    // get yyyymmdd for each day of this week
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String tueday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String wedday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String thuday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String satday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          // Week total
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Week Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '\Rs.${calculateWeekTotal(value, sunday, monday, tueday, wedday, thuday, friday, satday)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Today\'s Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '\Rs.${value.calculateDailyExpenseSummary()[convertDateTimeToString(DateTime.now())]?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // PageView for graphs
          Container(
            height: 200,
            child: PageView(
              controller: _pageController,
              children: [
                MyBarGraph(
                  maxY: calculateMaxAmount(value, sunday, monday, tueday,
                      wedday, thuday, friday, satday),
                  sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
                  monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                  tueAmount: value.calculateDailyExpenseSummary()[tueday] ?? 0,
                  wedAmount: value.calculateDailyExpenseSummary()[wedday] ?? 0,
                  thuAmount: value.calculateDailyExpenseSummary()[thuday] ?? 0,
                  friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                  satAmount: value.calculateDailyExpenseSummary()[satday] ?? 0,
                ),
                CategoryGraph(
                  maxY: calculateMaxAmount(value, sunday, monday, tueday,
                      wedday, thuday, friday, satday),
                  foodAmount:
                      value.calculateWeeklyExpenseSummaryByCategory()['food'] ??
                          0,
                  transportAmount:
                      value.calculateWeeklyExpenseSummaryByCategory()[
                              'transport'] ??
                          0,
                  shoppingAmount:
                      value.calculateWeeklyExpenseSummaryByCategory()[
                              'shopping'] ??
                          0,
                  leisureAmount:
                      value.calculateWeeklyExpenseSummaryByCategory()[
                              'leisure'] ??
                          0,
                  otherAmount: value
                          .calculateWeeklyExpenseSummaryByCategory()['other'] ??
                      0,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: const WormEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                activeDotColor: Color.fromARGB(255, 3, 64, 113),
                dotColor: Color.fromARGB(255, 246, 245, 245),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
