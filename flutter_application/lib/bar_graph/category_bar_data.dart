import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/individual_bar.dart';

class CategoryBarData {
  final double foodAmount;
  final double transportAmount;
  final double shoppingAmount;
  final double leisureAmount;
  final double otherAmount;

  CategoryBarData({
    required this.foodAmount,
    required this.transportAmount,
    required this.shoppingAmount,
    required this.leisureAmount,
    required this.otherAmount,
  });

  List<IndividualBar> barData = [];

  //initialize bar data
  void initializeCategoryBarData() {
    barData = [
      IndividualBar(x: 0, y: foodAmount),
      IndividualBar(x: 1, y: transportAmount),
      IndividualBar(x: 2, y: shoppingAmount),
      IndividualBar(x: 3, y: leisureAmount),
      IndividualBar(x: 4, y: otherAmount),
    ];
  }
}
