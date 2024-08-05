import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/category_graph.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/components/comparison_card.dart';
import 'package:flutter_application/date_time/date_time_helper.dart';
import 'package:flutter_application/pages/home-page.dart';
import 'package:provider/provider.dart';

class CompareExpensesScreen extends StatefulWidget {
  @override
  _CompareExpensesScreenState createState() => _CompareExpensesScreenState();
}

class _CompareExpensesScreenState extends State<CompareExpensesScreen> {
  String? selectedMonth1;
  String? selectedMonth2;
  final thresholdController = TextEditingController();

  final List<String> months = [
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

  int monthNameToNumber(String month) {
    return months.indexOf(month) + 1;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 84, 170, 239),
              Color.fromARGB(255, 206, 101, 224)
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('Compare Expenses by Category'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text(
            //             'Set Expense Threshold:',
            //             style: TextStyle(fontSize: 16.0),
            //           ),
            //           const SizedBox(height: 8),
            //           SizedBox(
            //             width: 375,
            //             child: TextField(
            //               controller: thresholdController,
            //               keyboardType: TextInputType.number,
            //               decoration: const InputDecoration(
            //                 border: OutlineInputBorder(),
            //                 hintText: 'Enter threshold value',
            //               ),
            //               onChanged: (value) {
            //                 setState(() {
            //                   // Handle threshold value change if needed
            //                 });
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Consumer<ExpenseData>(
                builder: (context, expenseData, child) {
                  Map<String, double> month1Summary = {};
                  Map<String, double> month2Summary = {};

                  if (selectedMonth1 != null) {
                    int monthNumber1 = monthNameToNumber(selectedMonth1!);
                    month1Summary =
                        expenseData.calculateMonthlyExpenseSummaryByCategory(
                            DateTime(DateTime.now().year, monthNumber1));
                  }
                  if (selectedMonth2 != null) {
                    int monthNumber2 = monthNameToNumber(selectedMonth2!);
                    month2Summary =
                        expenseData.calculateMonthlyExpenseSummaryByCategory(
                            DateTime(DateTime.now().year, monthNumber2));
                  }

                  double maxY = selectedMonth1 != null && selectedMonth2 != null
                      ? expenseData.maximumMonthlyExpenseByCategory(
                          DateTime(DateTime.now().year,
                              monthNameToNumber(selectedMonth1!)),
                          DateTime(DateTime.now().year,
                              monthNameToNumber(selectedMonth2!)),
                        )
                      : 10000;

                  // String month1 = DateTime(DateTime.now().year,
                  //         monthNameToNumber(selectedMonth1!))
                  //     .toString();
                  // String month2 = DateTime(DateTime.now().year,
                  //         monthNameToNumber(selectedMonth2!))
                  //     .toString();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton<String>(
                              hint: Text('Select First Month'),
                              value: selectedMonth1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMonth1 = newValue;
                                });
                              },
                              items: months.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            DropdownButton<String>(
                              hint: Text('Select Second Month'),
                              value: selectedMonth2,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMonth2 = newValue;
                                });
                              },
                              items: months.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 400,
                        child: selectedMonth1 != null && selectedMonth2 != null
                            ? Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CategoryGraph(
                                            maxY: maxY,
                                            foodAmount:
                                                month1Summary['food'] ?? 0,
                                            transportAmount:
                                                month1Summary['transport'] ?? 0,
                                            shoppingAmount:
                                                month1Summary['shopping'] ?? 0,
                                            leisureAmount:
                                                month1Summary['leisure'] ?? 0,
                                            otherAmount:
                                                month1Summary['other'] ?? 0,
                                          ),
                                        ),
                                        Expanded(
                                          child: CategoryGraph(
                                            maxY: maxY,
                                            foodAmount:
                                                month2Summary['food'] ?? 0,
                                            transportAmount:
                                                month2Summary['transport'] ?? 0,
                                            shoppingAmount:
                                                month2Summary['shopping'] ?? 0,
                                            leisureAmount:
                                                month2Summary['leisure'] ?? 0,
                                            otherAmount:
                                                month2Summary['other'] ?? 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                      child: BalanceCard(
                                    month1: DateTime(DateTime.now().year,
                                        monthNameToNumber(selectedMonth1!)),
                                    month2: DateTime(DateTime.now().year,
                                        monthNameToNumber(selectedMonth2!)),
                                  )),
                                ],
                              )
                            : const Center(
                                child: Text(
                                  'Please select two months to compare.',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
