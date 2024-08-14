import '/data/expense_data.dart';

// convert datatime object to string yyyymmdd

String convertDateTimeToString(DateTime dateTime) {
  //year in the format yyy
  String year = dateTime.year.toString();

  //month in the format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in the format dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  //final format yyyymmdd
  String yyyyMMdd = year + month + day;

  return yyyyMMdd;
}

Map<String, double> calculateDailyExpenseSummary() {
  Map<String, double> dailyExpenseSummary = {};

  var expenseData = ExpenseData();

  for (var expense in expenseData.overallExpenseList) {
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
  return dailyExpenseSummary;
}
