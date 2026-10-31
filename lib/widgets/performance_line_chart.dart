import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';

class PerformanceLineChart extends StatelessWidget {
  final List<ExamHistory> examHistory;

  const PerformanceLineChart({super.key, required this.examHistory});

  @override
  Widget build(BuildContext context) {
    if (examHistory.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final subjects = examHistory.first.subjectMarks.keys.toList();
    final colors = [
      AppTheme.primary,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.danger,
      AppTheme.accent,
    ];

    List<LineChartBarData> lines = [];
    for (int i = 0; i < subjects.length; i++) {
      final subject = subjects[i];
      final spots = <FlSpot>[];
      for (int j = 0; j < examHistory.length; j++) {
        spots.add(FlSpot(
          j.toDouble(),
          examHistory[j].subjectMarks[subject] ?? 0,
        ));
      }
      lines.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        color: colors[i % colors.length],
        barWidth: 2.5,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) =>
              FlDotCirclePainter(
            radius: 4,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: colors[i % colors.length],
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          color: colors[i % colors.length].withOpacity(0.05),
        ),
      ));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(
                    fontSize: 9, color: AppTheme.textSecondary),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= examHistory.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    examHistory[idx].examName,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: lines,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => AppTheme.textPrimary.withOpacity(0.9),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final subjectIdx = lines.indexOf(spot.bar);
                return LineTooltipItem(
                  '${subjectIdx < subjects.length ? subjects[subjectIdx] : ""}: ${spot.y.toStringAsFixed(0)}%',
                  const TextStyle(
                      color: Colors.white, fontSize: 11),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
