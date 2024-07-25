import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteTapped,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 22.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(158, 76, 76, 85),
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            title: Text(name),
            subtitle: Text(
              '${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}',
              style: const TextStyle(
                color: Colors.black, // Set text color to black
              ),
            ),
            trailing: Text(
              '\Rs. ${amount}',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold // Set text color to black
                  ),
            ),
          ),
        ));
  }
}
