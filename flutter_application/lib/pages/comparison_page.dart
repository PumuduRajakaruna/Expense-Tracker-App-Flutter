import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/category_graph.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/components/comparison_card.dart';
import 'package:flutter_application/date_time/date_time_helper.dart';
import 'package:flutter_application/pages/home-page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/components/expense_tile.dart';

class CompareExpensesScreen extends StatefulWidget {
  @override
  _CompareExpensesScreenState createState() => _CompareExpensesScreenState();
}

class _CompareExpensesScreenState extends State<CompareExpensesScreen>
    with SingleTickerProviderStateMixin {
  String? selectedMonth1;
  String? selectedMonth2;
  final thresholdController = TextEditingController();
  TabController? _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
                  Navigator.pop(context);
                },
              ),
            ),
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

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(156, 241, 243, 244),
                                      width: 2), // Border color and width
                                  borderRadius:
                                      BorderRadius.circular(5), // Border radius
                                ),
                                child: Center(
                                  child: DropdownButton<String>(
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
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(156, 241, 243, 244),
                                      width: 2), // Border color and width
                                  borderRadius:
                                      BorderRadius.circular(5), // Border radius
                                ),
                                child: Center(
                                  child: DropdownButton<String>(
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: selectedMonth1 != null && selectedMonth2 != null
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    156,
                                                    241,
                                                    243,
                                                    244), // Border color
                                                width: 2.0, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CategoryGraph(
                                                maxY: maxY,
                                                foodAmount:
                                                    month1Summary['food'] ?? 0,
                                                transportAmount: month1Summary[
                                                        'transport'] ??
                                                    0,
                                                shoppingAmount:
                                                    month1Summary['shopping'] ??
                                                        0,
                                                leisureAmount:
                                                    month1Summary['leisure'] ??
                                                        0,
                                                otherAmount:
                                                    month1Summary['other'] ?? 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    156,
                                                    241,
                                                    243,
                                                    244), // Border color
                                                width: 2.0, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CategoryGraph(
                                                maxY: maxY,
                                                foodAmount:
                                                    month2Summary['food'] ?? 0,
                                                transportAmount: month2Summary[
                                                        'transport'] ??
                                                    0,
                                                shoppingAmount:
                                                    month2Summary['shopping'] ??
                                                        0,
                                                leisureAmount:
                                                    month2Summary['leisure'] ??
                                                        0,
                                                otherAmount:
                                                    month2Summary['other'] ?? 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    height: 200,
                                    child: BalanceCard(
                                      month1: DateTime(DateTime.now().year,
                                          monthNameToNumber(selectedMonth1!)),
                                      month2: DateTime(DateTime.now().year,
                                          monthNameToNumber(selectedMonth2!)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 8.0),
                                          child: TabBar(
                                            controller: _tabController,
                                            indicator: BoxDecoration(),
                                            labelStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                            unselectedLabelStyle:
                                                const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14.0,
                                            ),
                                            labelColor: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            unselectedLabelColor:
                                                Color.fromARGB(255, 57, 1, 69),
                                            tabs: [
                                              Tab(text: selectedMonth1),
                                              Tab(text: selectedMonth2),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              ListView.builder(
                                                itemCount: expenseData
                                                    .getExpensesByMonth(DateTime(
                                                        DateTime.now().year,
                                                        monthNameToNumber(
                                                            selectedMonth1!)))
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final expense = expenseData
                                                      .getExpensesByMonth(DateTime(
                                                          DateTime.now().year,
                                                          monthNameToNumber(
                                                              selectedMonth1!)))[index];
                                                  return ExpenseTile(
                                                    name: expense.name,
                                                    amount: expense.amount,
                                                    dateTime: expense.dateTime,
                                                    category: expense.category,
                                                    deleteTapped: (p0) =>
                                                        expenseData
                                                            .deleteExpense(
                                                                expense),
                                                  );
                                                },
                                              ),
                                              ListView.builder(
                                                itemCount: expenseData
                                                    .getExpensesByMonth(DateTime(
                                                        DateTime.now().year,
                                                        monthNameToNumber(
                                                            selectedMonth2!)))
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final expense = expenseData
                                                      .getExpensesByMonth(DateTime(
                                                          DateTime.now().year,
                                                          monthNameToNumber(
                                                              selectedMonth2!)))[index];
                                                  return ExpenseTile(
                                                    name: expense.name,
                                                    amount: expense.amount,
                                                    dateTime: expense.dateTime,
                                                    category: expense.category,
                                                    deleteTapped: (p0) =>
                                                        expenseData
                                                            .deleteExpense(
                                                                expense),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
