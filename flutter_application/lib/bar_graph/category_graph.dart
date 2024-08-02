import 'package:flutter/material.dart';
import 'package:flutter_application/bar_graph/category_bar_data.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryGraph extends StatelessWidget {
  final double? maxY;
  final double foodAmount;
  final double transportAmount;
  final double shoppingAmount;
  final double leisureAmount;
  final double otherAmount;

  const CategoryGraph({
    super.key,
    required this.maxY,
    required this.foodAmount,
    required this.transportAmount,
    required this.shoppingAmount,
    required this.leisureAmount,
    required this.otherAmount,
  });

  @override
  Widget build(BuildContext context) {
    CategoryBarData myBarData = CategoryBarData(
      foodAmount: foodAmount,
      transportAmount: transportAmount,
      shoppingAmount: shoppingAmount,
      leisureAmount: leisureAmount,
      otherAmount: otherAmount,
    );

    myBarData.initializeCategoryBarData();

    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, getTitlesWidget: getBottomTitles))),
      barGroups: myBarData.barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: Color.fromARGB(255, 13, 75, 146),
                    width: 25.0,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: maxY, color: Colors.grey[200]))
              ],
            ),
          )
          .toList(),
    ));
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  // const style = TextStyle(
  //   color: Colors.white,
  //   fontWeight: FontWeight.bold,
  //   fontSize: 14,
  // );
  Widget icon;
  switch (value.toInt()) {
    case 0:
      // text = const Text('F', style: style);
      icon = const Icon(Icons.fastfood, color: Colors.white, size: 18);
      break;
    case 1:
      icon = const Icon(Icons.directions_bus, color: Colors.white, size: 18);
      break;
    case 2:
      icon = const Icon(Icons.shopping_cart, color: Colors.white, size: 18);
      break;
    case 3:
      icon = const Icon(Icons.beach_access, color: Colors.white, size: 18);
      break;
    case 4:
      icon = const Icon(Icons.category, color: Colors.white, size: 18);
      break;
    default:
      icon = const Icon(Icons.category, color: Colors.white, size: 18);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: icon);
}
