import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shader_studio/pages/intelligence/voice_api.dart';

class EQ extends StatelessWidget {
  final List<({FrequencySpectrum spectrum, double value})> data;

  const EQ({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
            barTouchData: BarTouchData(enabled: false),
            borderData: FlBorderData(show: false),
            maxY: 40,
            minY: -40,
            barGroups: data.map((e) {
              return BarChartGroupData(
                x: data.indexOf(e),
                barRods: [
                  BarChartRodData(
                    width: 8,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purpleAccent,
                        Colors.purple,
                      ],
                    ),
                    toY: 3 * e.value.abs() * (1 - (e.value / (e.value + 15))),
                    fromY:
                        3 * -e.value.abs() * (1 - (e.value / (e.value + 15))),
                  ),
                ],
              );
            }).toList(),
          ),
          swapAnimationCurve: Curves.easeInOut,
          swapAnimationDuration: const Duration(milliseconds: 180),
        ),
      ),
    );
  }
}
