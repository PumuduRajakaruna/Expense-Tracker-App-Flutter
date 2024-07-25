import 'package:flutter/material.dart';
import 'package:flutter_application/components/expense_summary.dart';
import 'package:flutter_application/components/expense_tile.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/models/expense_item.dart';
import 'package:flutter_application/date_time/date_time_helper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controller
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Add New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(hintText: 'Expense Name'),
              ),
              TextField(
                controller: newExpenseAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Expense Amount'),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${selectedDate!.day.toString()}/${selectedDate!.month.toString()}/${selectedDate!.year.toString()}',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: save,
              child: Text("Save"),
            ),

            //cancel button
            MaterialButton(
              onPressed: cancel,
              child: Text("Cancel"),
            ),
          ],
        );
      }),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //save
  void save() {
    // only save if both fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      String amount = '${newExpenseAmountController.text}';

      //create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: selectedDate ?? DateTime.now(),
      );

      //add new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }
    Navigator.pop(context);
    clearTextFields();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clearTextFields();
  }

  void clearTextFields() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: ((context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.grey[100],
            child: const Icon(Icons.add),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 84, 170, 239),
                  Color.fromARGB(255, 206, 101, 224),
                ],
              ),
            ),
            child: Column(children: [
              const SizedBox(height: 25),
              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              const SizedBox(height: 20),

              //exepenses list
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) => ExpenseTile(
                          name: value.getAllExpenseList()[index].name,
                          amount: value.getAllExpenseList()[index].amount,
                          dateTime: value.getAllExpenseList()[index].dateTime,
                          deleteTapped: (p0) =>
                              deleteExpense(value.getAllExpenseList()[index]),
                        )),
              ),
            ]),
          ))),
    );
  }
}
