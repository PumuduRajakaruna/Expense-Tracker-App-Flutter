import 'package:flutter/material.dart';
import 'package:flutter_application/data/hive_database.dart';

import '/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  //list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    db.saveData(overallExpenseList);
    notifyListeners();
  }

  //get weekday from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Invalid';
    }
  }

  //get the date for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backward from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Monday') {
        startOfWeek = today.subtract(Duration(days: i));
        break;
      }
    }
    if (startOfWeek == null) {
      throw Exception("Start of week not found");
    }

    return startOfWeek;
  }

  // Calculate daily expense summary
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    calculateWeeklyExpenseSummaryByCategory();

    return dailyExpenseSummary;
  }

  Map<String, double> calculateWeeklyExpenseSummaryByCategory() {
    Map<String, double> weeklyExpenseSummaryByCategory = {};

    // Get the start and end of the current week
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    for (var expense in overallExpenseList) {
      // Convert amount from String to int
      double amount = 0.0;
      try {
        amount = double.parse(expense.amount);
      } catch (e) {
        print('Invalid amount for expense ${expense.name}: ${expense.amount}');
        continue; // Skip this expense if amount is invalid
      }

      // Check if the expense date is within the current week
      if (expense.dateTime
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          expense.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        String category = expense.category ?? 'Uncategorized';

        if (weeklyExpenseSummaryByCategory.containsKey(category)) {
          weeklyExpenseSummaryByCategory[category] =
              weeklyExpenseSummaryByCategory[category]! + amount;
        } else {
          weeklyExpenseSummaryByCategory[category] = amount;
        }
      }
    }

    // Log the weekly expense summary by category
    print('Weekly Expense Summary by Category:');
    weeklyExpenseSummaryByCategory.forEach((category, total) {
      print('$category: \$${total.toStringAsFixed(2)}');
    });

    return weeklyExpenseSummaryByCategory;
  }

  // Convert DateTime object to string yyyymmdd
  String convertDateTimeToString(DateTime dateTime) {
    // Year in the format yyy
    String year = dateTime.year.toString();

    // Month in the format mm
    String month = dateTime.month.toString().padLeft(2, '0');

    // Day in the format dd
    String day = dateTime.day.toString().padLeft(2, '0');

    // Final format yyyymmdd
    String yyyyMMdd = year + month + day;

    return yyyyMMdd;
  }
}
