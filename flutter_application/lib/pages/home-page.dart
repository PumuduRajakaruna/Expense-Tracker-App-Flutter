import 'package:flutter/material.dart';
import 'package:flutter_application/components/expense_summary.dart';
import 'package:flutter_application/components/expense_tile.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/models/expense_item.dart';
import 'package:flutter_application/pages/comparison_page.dart';
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
  Category? selectedCategory;
  //Enum? cat;
  String? category;

  // For filtering
  String? _selectedFilterCategory;
  final List<String> _categories = [
    'all',
    'food',
    'transport',
    'shopping',
    'leisure',
    'other'
  ];
  final Map<String, IconData> _categoryIcons = {
    'all': Icons.all_inclusive,
    'food': Icons.fastfood,
    'transport': Icons.directions_bus,
    'shopping': Icons.shopping_cart,
    'leisure': Icons.beach_access,
    'other': Icons.category,
  };

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
          title: const Center(
            child: Text(
              'Add New Expense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newExpenseNameController,
                decoration: InputDecoration(
                  hintText: 'Expense Name',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
              TextField(
                controller: newExpenseAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Expense Amount',
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                    )),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
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
                      label: Text(
                        selectedDate == null
                            ? 'Select Date'
                            : '${selectedDate!.day.toString()}/${selectedDate!.month.toString()}/${selectedDate!.year.toString()}',
                      ),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<Category>(
                      hint: const Text('Select Category'),
                      value: selectedCategory,
                      onChanged: (Category? newValue) {
                        setState(() {
                          // cat= newValue;
                          category = newValue.toString().split('.').last;
                          selectedCategory = newValue;
                        });
                      },
                      items: Category.values
                          .map<DropdownMenuItem<Category>>((Category value) {
                        return DropdownMenuItem<Category>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                //cancel button
                OutlinedButton(
                  onPressed: cancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
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
        newExpenseAmountController.text.isNotEmpty &&
        category != null) {
      String amount = '${newExpenseAmountController.text}';

      //create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: selectedDate ?? DateTime.now(),
        category: category,
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
    selectedCategory = null;
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
              AppBar(
                  title: const Text('Weekly Summary'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompareExpensesScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.compare_arrows_rounded,
                          color: Colors.white, // Icon color
                        ),
                        label: const Text(
                          'Compare',
                          style: TextStyle(
                            color: Colors.white, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 3, 63, 166),
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ]),

              const SizedBox(height: 10),

              //weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              const SizedBox(height: 8),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     child: SizedBox(
              //       width: 375,
              //       child: PopupMenuButton<String>(
              //         tooltip: 'Filter expenses by category',
              //         icon: const Icon(Icons.filter_list),
              //         onSelected: (String newValue) {
              //           setState(() {
              //             _selectedFilterCategory = newValue;
              //           });
              //         },
              //         itemBuilder: (BuildContext context) {
              //           return _categories.map((String category) {
              //             return PopupMenuItem<String>(
              //               value: category,
              //               child: Row(
              //                 children: [
              //                   Icon(
              //                     _categoryIcons[category],
              //                     size: 24.0,
              //                     color: Color.fromARGB(255, 0, 0, 0),
              //                   ),
              //                   const SizedBox(width: 8),
              //                   Text(category),
              //                 ],
              //               ),
              //             );
              //           }).toList();
              //         },
              //       ),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Filter Expense Data',
                        prefixIcon: Icon(Icons.filter_list),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors
                                .transparent, // Make the border transparent
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors
                                .transparent, // Make the border transparent
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(
                            color: Colors
                                .transparent, // Make the border transparent
                          ),
                        ),
                      ),
                      value: _selectedFilterCategory,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFilterCategory = newValue;
                        });
                      },
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                _categoryIcons[category],
                                size: 24.0,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(category),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              //exepenses list
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) {
                      final expense = value.getAllExpenseList()[index];
                      if (_selectedFilterCategory == null ||
                          _selectedFilterCategory == 'all' ||
                          expense.category == _selectedFilterCategory) {
                        return ExpenseTile(
                          name: expense.name,
                          amount: expense.amount,
                          dateTime: expense.dateTime,
                          category: expense.category,
                          deleteTapped: (p0) => deleteExpense(expense),
                        );
                      }
                      return Container();
                    }),
              ),
            ]),
          ))),
    );
  }
}
