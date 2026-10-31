import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';

class SubjectBarChart extends StatelessWidget {
  final List<SubjectMarks> subjects;

  const SubjectBarChart({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppTheme.primary,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.danger,
      AppTheme.accent,
    ];

    return BarChart(
      BarChartData(
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
                if (idx < 0 || idx >= subjects.length) return const SizedBox();
                final name = subjects[idx].subjectName;
                final shortName = name.length > 4 ? name.substring(0, 4) : name;
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    shortName,
                    style: const TextStyle(
                        fontSize: 9,
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
        barGroups: List.generate(subjects.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: subjects[i].percentage,
                color: colors[i % colors.length],
                width: 20,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: colors[i % colors.length].withOpacity(0.08),
                ),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                AppTheme.textPrimary.withOpacity(0.9),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${subjects[groupIndex].subjectName}\n${rod.toY.toStringAsFixed(1)}%',
                const TextStyle(color: Colors.white, fontSize: 11),
              );
            },
          ),
        ),
      ),
    );
  }
}
