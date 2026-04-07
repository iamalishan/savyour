import 'package:fl_chart/fl_chart.dart';

import '../../constants/app_imports.dart';
import '../../models/fb_product_model.dart';

class LineChartPrice extends StatelessWidget {
  const LineChartPrice({
    super.key,
    required this.product,
    required this.fbProductModel,
    this.fontSize = 14
  });

  final Product product;
  final FBProductModel fbProductModel;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(seconds: 1),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: (getPriceData().length - 1).toDouble(),
        maxY: getMaxPrice(),
        minY: getMinPrice(),
      );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      // tooltipBgColor: Colors.black87,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((LineBarSpot touchedSpot) {
          final price = touchedSpot.y;
          final index = touchedSpot.x.toInt();
          final date = getPriceData()[index]['date'] as DateTime;

          return LineTooltipItem(
            '${date.day}/${date.month}/${date.year}\nRs ${price.toStringAsFixed(0)}',
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          );
        }).toList();
      },
    ),
    // touchIndicatorData: TouchIndicatorData(
    //   enabled: false, // ✅ Disable vertical/horizontal lines
    // ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_3,
      ];

  FlGridData get gridData => FlGridData(
    show: true,
    drawVerticalLine: false, // Or true if you want vertical lines
    getDrawingHorizontalLine: (value) {
      if (uniquePriceValues.contains(value)) {
        return FlLine(
          color: Colors.black.withAlpha(20),
          strokeWidth: 1,
        );
      }
      return FlLine(color: Colors.transparent); // ❌ Hide grid line
    },
  );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withAlpha(20), width: 4),
          left: BorderSide(color: Colors.black.withAlpha(20), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    gradient: const LinearGradient(
      colors: [
        Colors.black, // 🔴 Darker red
        Colors.black12, // orange
      ],
    ),

    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, bar, index) {
        return FlDotCirclePainter(
          radius: 4,
          color: Colors.white,
          strokeColor: Color(0xffb71c1c), // 🔴 Same dark red
          strokeWidth: 2,
        );
      },
    ),

    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          Colors.black,
          Colors.black12,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),

    spots: spots,
  );

  List<FlSpot> get spots {
    final priceData = getPriceData();
    return priceData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value['price']))
        .toList();
  }

  List<Map<String, dynamic>> getPriceData() {
    // First price from product's createdAt
    DateTime firstPriceDate = product.createdAt!;
    double firstPrice =
        double.parse(product.variants!.first.compareAtPrice.toString());

    // Last price from product's variant price
    DateTime lastPriceDate = DateTime.now();
    double lastPrice = double.parse(product.variants!.first.price);

    // Initialize the priceData list with first and last price points
    List<Map<String, dynamic>> priceData = [
      {
        'date': firstPriceDate,
        'price': firstPrice,
      }, // First price from createdAt
      {
        'date': lastPriceDate,
        'price': lastPrice,
      }, // Last price from current date
    ];

    // Adding all price history data from fbProductModel
    for (int i = 0; i < fbProductModel.priceHistoryDate.length; i++) {
      priceData.add({
        'date': fbProductModel.priceHistoryDate[i],
        'price': double.parse(fbProductModel.priceHistoryPrice[i].toString()),
      });
    }

    // Sort price data by date (ascending order)
    priceData.sort((a, b) => a['date'].compareTo(b['date']));

    return priceData;
  }

  Set<double> get uniquePriceValues {
    return getPriceData()
        .map<double>((e) => e['price'] as double)
        .toSet();
  }


  double getMaxPrice() {
    final priceData = getPriceData();
    double maxPrice = priceData
        .map((e) => e['price'])
        .reduce((value, element) => value > element ? value : element);
    return maxPrice;
  }

  double getMinPrice() {
    final priceData = getPriceData();
    double minPrice = priceData
        .map((e) => e['price'])
        .reduce((value, element) => value < element ? value : element);
    return minPrice;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );

    // Show only if the value exists in the real price points
    if (!uniquePriceValues.contains(value)) {
      return const SizedBox.shrink(); // Don't render label
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toStringAsFixed(0),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 200,
    reservedSize: fontSize * 4,
  );



  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );

    // Get the price data
    final priceData = getPriceData();

    // Convert the value (X-axis index) to an integer for matching the data
    int index = value.toInt();

    // Ensure the index is valid
    if (index >= 0 && index < priceData.length) {
      DateTime date = priceData[index]['date'];
      int year = date.year;

      // Show year with 1-year gap
      return SideTitleWidget(
        meta: meta,
        child: Text(
          year.toString(),
          style: style,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Hide invalid or unnecessary labels
    return const SizedBox.shrink();
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: fontSize*4,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );
}





//
// ============================================================================
//
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
