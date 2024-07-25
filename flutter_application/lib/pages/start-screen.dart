import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/expense_summary.dart';
import 'package:flutter_application/components/expense_tile.dart';
import 'package:flutter_application/data/expense_data.dart';
import 'package:flutter_application/models/expense_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/pages/home-page.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(
    //   Duration(seconds: 5), // Wait for 5 seconds
    //   () {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => HomePage()),
    //     );
    //   },
    // );
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/home_icon.png',
              height: 200,
            ),
            const Text(
              'Expense Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 255, 204, 0), // Light yellow
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              label: const Text(
                'Start',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
