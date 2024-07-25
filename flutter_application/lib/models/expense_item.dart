enum Category { food, transport, shopping, leisure, other }

class ExpenseItem {
  final String name;
  final String amount;
  final DateTime dateTime;
  // final Category category;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.dateTime,
    // required this.category,
  });
}
