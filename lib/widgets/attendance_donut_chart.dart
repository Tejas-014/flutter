import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class AttendanceDonutChart extends StatelessWidget {
  final double present;
  final double absent;

  const AttendanceDonutChart({
    super.key,
    required this.present,
    required this.absent,
  });

  @override
  Widget build(BuildContext context) {
    final total = present + absent;
    final presentPct = total > 0 ? (present / total * 100) : 0.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 3,
            centerSpaceRadius: 45,
            sections: [
              PieChartSectionData(
                color: AppTheme.success,
                value: present,
                title: '',
                radius: 35,
              ),
              PieChartSectionData(
                color: AppTheme.danger,
                value: absent,
                title: '',
                radius: 35,
              ),
            ],
            pieTouchData: PieTouchData(
              touchCallback: (event, response) {},
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${presentPct.toStringAsFixed(1)}%',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary),
            ),
            const Text(
              'Present',
              style: TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
