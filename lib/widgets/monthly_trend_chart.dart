import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';

class MonthlyTrendChart extends StatelessWidget {
  final List<SubjectAttendance> attendanceList;

  const MonthlyTrendChart({super.key, required this.attendanceList});

  @override
  Widget build(BuildContext context) {
    // Aggregate monthly attendance across all subjects
    final Map<String, List<double>> monthlyData = {};
    for (final att in attendanceList) {
      for (final rec in att.monthlyRecords) {
        monthlyData.putIfAbsent(rec.month, () => []);
        monthlyData[rec.month]!.add(rec.percentage);
      }
    }

    final months = monthlyData.keys.toList();
    final averages = months.map((m) {
      final vals = monthlyData[m]!;
      return vals.reduce((a, b) => a + b) / vals.length;
    }).toList();

    final spots = List.generate(
        months.length, (i) => FlSpot(i.toDouble(), averages[i]));

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
                if (idx < 0 || idx >= months.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    months[idx],
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600),
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
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(
              colors: [AppTheme.success, AppTheme.accent],
            ),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: AppTheme.success,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.success.withOpacity(0.2),
                  AppTheme.success.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) =>
                AppTheme.textPrimary.withOpacity(0.9),
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      '${s.y.toStringAsFixed(1)}%',
                      const TextStyle(color: Colors.white, fontSize: 11),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
