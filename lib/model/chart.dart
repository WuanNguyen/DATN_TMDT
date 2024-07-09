import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  final String year;
  final int sales;

  SalesData(this.year, this.sales);
}

class ProductChart extends StatefulWidget {
  const ProductChart({super.key});

  @override
  State<ProductChart> createState() => _ProductChartState();
}

final data = [
      SalesData('T4', 5),
      SalesData('T5', 25),
      SalesData('T6', 100),
      SalesData('T7', 90),
    ];
    final data1 = [
      SalesData('T4', 10),
      SalesData('T5', 27),
      SalesData('T6', 75),
      SalesData('T7', 75),
    ];
    final data2 = [
      SalesData('T4', 0),
      SalesData('T5', 0),
      SalesData('T6', 0),
      SalesData('T7', 0),
    ];

class _ProductChartState extends State<ProductChart> {

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Sales Data'),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<SalesData, String>>[
          ColumnSeries<SalesData, String>(
            dataSource: data,
            xValueMapper: (SalesData sales, _) => sales.year  ,
            yValueMapper: (SalesData sales, _) => sales.sales,
            name: 'Data 1',
            color: Colors.red,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
          ColumnSeries<SalesData, String>(
            dataSource: data1,
            xValueMapper: (SalesData sales, _) => sales.year  ,
            yValueMapper: (SalesData sales, _) => sales.sales,
            name: 'Data 2',
            color: Colors.green,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    )
          ],
        )
      );
  }
}