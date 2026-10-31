import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';

class IAComparisonChart extends StatelessWidget {
  final SubjectMarks subject;

  const IAComparisonChart({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 20,
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
              reservedSize: 24,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(
                    fontSize: 9, color: AppTheme.textSecondary),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final labels = ['IA 1', 'IA 2'];
                final idx = value.toInt();
                if (idx < 0 || idx >= labels.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[idx],
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary)),
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
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: subject.ia1Marks,
                color: AppTheme.primary,
                width: 40,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 20,
                  color: AppTheme.primary.withOpacity(0.08),
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: subject.ia2Marks,
                color: AppTheme.secondary,
                width: 40,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 20,
                  color: AppTheme.secondary.withOpacity(0.08),
                ),
              ),
            ],
          ),
        ],
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                AppTheme.textPrimary.withOpacity(0.9),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = groupIndex == 0 ? 'IA 1' : 'IA 2';
              return BarTooltipItem(
                '$label: ${rod.toY.toStringAsFixed(0)}/20',
                const TextStyle(color: Colors.white, fontSize: 11),
              );
            },
          ),
        ),
      ),
    );
  }
}
