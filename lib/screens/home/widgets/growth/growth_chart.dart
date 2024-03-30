import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_baby/configs/database.dart';

class GrowthChart extends StatefulWidget {
  final List<Growth> growths;
  const GrowthChart({super.key, required this.growths});

  @override
  State<GrowthChart> createState() => _GrowthChartState();
}

class _GrowthChartState extends State<GrowthChart> {
  List<Color> gradientColors = [
    const Color(0xFF11A492),
    const Color(0xFF6B60AC),
  ];

  List<Growth> get _sortGrowths {
    if (widget.growths.isEmpty) return [];
    return widget.growths.sorted((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  int get dayRange {
    if (_sortGrowths.isEmpty) return 0;
    return _sortGrowths.last.createdAt
        .difference(_sortGrowths.first.createdAt)
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.25,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(mainData()),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    late Widget text;
    final maxRange = dayRange < 5 ? dayRange : 5;
    final rangeIndices = [];
    for (var i = 1; i <= maxRange; i++) {
      rangeIndices.add((dayRange / maxRange * i).toInt());
    }

    if (rangeIndices.contains(value.toInt())) {
      text = Text(
          DateFormat('dd MMM').format(_sortGrowths[value.toInt()].createdAt),
          style: style);
    } else {
      text = const SizedBox.shrink();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    late String text;
    final range = widget.growths
            .reduce((value, element) =>
                value.weight > element.weight ? value : element)
            .weight /
        5;

    final rangeIndices = [];
    for (var i = 1; i <= 5; i++) {
      rangeIndices.add((range * i).toInt());
    }

    if (rangeIndices.contains(value.toInt())) {
      text = value.toInt().toString();
    } else {
      return const SizedBox.shrink();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
        //   drawVerticalLine: true,
        //   horizontalInterval: 1,
        //   verticalInterval: 1,
        //   getDrawingHorizontalLine: (value) {
        //     return const FlLine(
        //       color: Colors.transparent,
        //       strokeWidth: 1,
        //     );
        //   },
        //   getDrawingVerticalLine: (value) {
        //     return const FlLine(
        //       color: Colors.transparent,
        //       strokeWidth: 1,
        //     );
        //   },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: _sortGrowths.isNotEmpty
              ? _sortGrowths
                  .map((e) => FlSpot(
                      e.createdAt
                          .difference(_sortGrowths[0].createdAt)
                          .inDays
                          .toDouble(),
                      e.weight))
                  .toList()
              : [],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
