import 'package:flutter_application/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  // reference our boxfinal
  final _mybox = Hive.box('expenses_db2');

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    // finally lets store in our database
    _mybox.put('ALL_EXPENSES', allExpensesFormatted);
  }

  // read data
  List<ExpenseItem> readData() {
    List savedExpenses = _mybox.get('ALL_EXPENSES') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense item
      ExpenseItem expense =
          ExpenseItem(name: name, amount: amount, dateTime: dateTime);
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
