import 'package:flutter/material.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '/pages/start-screen.dart';

void main() async {
  // initialize the database
  await Hive.initFlutter();

  // open a hive box
  await Hive.openBox('expenses_db2');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartScreen(),
      ),
    );
  }
}
