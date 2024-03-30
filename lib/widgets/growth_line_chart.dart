// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class WeightLineChart extends StatefulWidget {
//   final List<WeightData> weightData;

//   const WeightLineChart({Key? key, required this.weightData}) : super(key: key);

//   @override
//   State<WeightLineChart> createState() => _WeightLineChartState();
// }

// class WeightData {
//   final DateTime date;
//   final double weight;

//   WeightData(this.date, this.weight);
// }

// class _WeightLineChartState extends State<WeightLineChart> {
//   FlSpot? touchedSpot;

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       // Removed axisTitles from LineChartData
//       LineChartData(
//         borderData: FlBorderData(show: borderLines),
//         gridData: FlGridData(show: gridLines),
//         titlesData: titlesData(touchedSpot),
//         lineBarsData: lineBarsData(),
//       ),
//     );
//   }

//   bool get borderLines => true;
//   bool get gridLines => true;

//   FlTitlesData titlesData(FlSpot? touchedSpot) {
//     return TitlesData(
//       bottomTitles: bottomTitles(),
//       rightTitles: SideTitles(showTitles: false),
//       topTitles: SideTitles(showTitles: false),
//       touchedSpot: touchedSpot,
//     );
//   }

//   LeftTitles leftTitles() {
//     return LeftTitles(
//       axisNameWidget: Text('Weight (kg)', style: const TextStyle(fontSize: 16, color: Colors.grey)),
//       showTitles: true,
//       textMargin: 10,
//     );
//   }

//   BottomTitles bottomTitles() {
//     return BottomTitles(
//       showBottomTitles: true,
//       aligned: Alignment.center,
//       axisSide: AxisSide.bottom,
//       getTitles: (double value) {
//         final int index = value.toInt();
//         if (index < widget.weightData.length) {
//           return DateFormat('MMM dd').format(widget.weightData[index].date);
//         }
//         return '';
//       },
//     );
//   }

//   List<LineChartBarData> lineBarsData() {
//     final LineChartBarData lineChartBarData = LineChartBarData(
//       spots: widget.weightData.map((data) => FlSpot(data.date.millisecondsSinceEpoch.toDouble(), data.weight)).toList(),
//       isCurved: true,
//       colors: [Colors.blueAccent],
//       barWidth: 2,
//       dotData: FlDotData(show: false),
//     );
//     return [lineChartBarData];
//   }
// }