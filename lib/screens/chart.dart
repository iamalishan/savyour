// import 'package:faster/common/models/fb_product_model.dart';
// import 'package:faster/common/models/product_model.dart';
// import 'package:faster/constants/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class LineChartPrice extends StatelessWidget {
//   const LineChartPrice({
//     super.key,
//     required this.product,
//     required this.fbProductModel,
//   });

//   final Product product;
//   final FBProductModel fbProductModel;

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       sampleData1,
//       duration: const Duration(seconds: 1),
//     );
//   }

//   LineChartData get sampleData1 => LineChartData(
//         lineTouchData: lineTouchData1,
//         gridData: gridData,
//         titlesData: titlesData1,
//         borderData: borderData,
//         lineBarsData: lineBarsData1,
//         minX: 0,
//         maxX: (getPriceData().length - 1).toDouble(),
//         maxY: getMaxPrice(),
//         minY: getMinPrice(),
//       );

//   LineTouchData get lineTouchData1 => LineTouchData(
//         handleBuiltInTouches: true,
//       );

//   FlTitlesData get titlesData1 => FlTitlesData(
//         bottomTitles: AxisTitles(
//           sideTitles: bottomTitles,
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: leftTitles(),
//         ),
//       );

//   List<LineChartBarData> get lineBarsData1 => [
//         lineChartBarData1_3,
//       ];

//   FlGridData get gridData => const FlGridData(show: false);

//   FlBorderData get borderData => FlBorderData(
//         show: true,
//         border: Border(
//           bottom: BorderSide(color: Colors.orange.withOpacity(0.2), width: 4),
//           left: BorderSide(color: Colors.orange.withOpacity(0.2), width: 4),
//           right: const BorderSide(color: Colors.transparent),
//           top: const BorderSide(color: Colors.transparent),
//         ),
//       );

//   LineChartBarData get lineChartBarData1_3 => LineChartBarData(
//       isCurved: true,
//       color: Colors.orange,
//       barWidth: 3,
//       isStrokeCapRound: true,
//       dotData: const FlDotData(show: true),
//       belowBarData: BarAreaData(show: false),
//       spots: spots);

//   List<FlSpot> get spots {
//     final priceData = getPriceData();
//     return priceData
//         .asMap()
//         .entries
//         .map((entry) => FlSpot(entry.key.toDouble(), entry.value['price']))
//         .toList();
//   }

//   List<Map<String, dynamic>> getPriceData() {
//     // First price from product's createdAt
//     DateTime firstPriceDate = product.createdAt;
//     double firstPrice =
//         double.parse(product.variants.first.compareAtPrice.toString());

//     // Last price from product's variant price
//     DateTime lastPriceDate = DateTime.now();
//     double lastPrice = double.parse(product.variants.first.price);

//     // Initialize the priceData list with first and last price points
//     List<Map<String, dynamic>> priceData = [
//       {
//         'date': firstPriceDate,
//         'price': firstPrice,
//       }, // First price from createdAt
//       {
//         'date': lastPriceDate,
//         'price': lastPrice,
//       }, // Last price from current date
//     ];

//     // Adding all price history data from fbProductModel
//     for (int i = 0; i < fbProductModel.priceHistoryDate.length; i++) {
//       priceData.add({
//         'date': fbProductModel.priceHistoryDate[i],
//         'price': double.parse(fbProductModel.priceHistoryPrice[i].toString()),
//       });
//     }

//     // Sort price data by date (ascending order)
//     priceData.sort((a, b) => a['date'].compareTo(b['date']));

//     return priceData;
//   }

//   double getMaxPrice() {
//     final priceData = getPriceData();
//     double maxPrice = priceData
//         .map((e) => e['price'])
//         .reduce((value, element) => value > element ? value : element);
//     return maxPrice;
//   }

//   double getMinPrice() {
//     final priceData = getPriceData();
//     double minPrice = priceData
//         .map((e) => e['price'])
//         .reduce((value, element) => value < element ? value : element);
//     return minPrice;
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     return SideTitleWidget(
//       meta: meta,
//       child: Text(
//         value.toStringAsFixed(0), // Round price to whole number
//         style: style,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   SideTitles leftTitles() => SideTitles(
//         getTitlesWidget: leftTitleWidgets,
//         showTitles: true,
//         interval: 1000, // Display prices at intervals of 1000
//         reservedSize: 50,
//       );

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );

//     // Get the price data
//     final priceData = getPriceData();

//     // Convert the value (X-axis index) to an integer for matching the data
//     int index = value.toInt();

//     // Ensure the index is valid
//     if (index >= 0 && index < priceData.length) {
//       DateTime date = priceData[index]['date'];
//       int year = date.year;

//       // Show year with 1-year gap
//       return SideTitleWidget(
//         meta: meta,
//         child: Text(
//           year.toString(),
//           style: style,
//           textAlign: TextAlign.center,
//         ),
//       );
//     }

//     // Hide invalid or unnecessary labels
//     return const SizedBox.shrink();
//   }

//   SideTitles get bottomTitles => SideTitles(
//         showTitles: true,
//         reservedSize: 50,
//         interval: 1,
//         getTitlesWidget: bottomTitleWidgets,
//       );
// }






// ============================================================================

  //  Obx(
  //                           () => Visibility(
  //                             visible: controller.showHistory.value,
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 const Padding(
  //                                   padding: EdgeInsets.all(8.0),
  //                                   child: ReuseText(
  //                                     title: "Price Tracker",
  //                                     fontSize: 25,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(20.0),
  //                                   child: SizedBox(
  //                                       height: 200,
  //                                       child: LineChartPrice(
  //                                         product: product,
  //                                         fbProductModel: fbProduc,
  //                                       )),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),



  // ====================================================


// package used 
// fl_chart: ^0.70.2