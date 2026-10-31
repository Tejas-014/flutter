import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/gradient_card.dart';
import '../widgets/performance_line_chart.dart';
import '../widgets/subject_bar_chart.dart';
import '../widgets/attendance_donut_chart.dart';
import '../widgets/monthly_trend_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _filter = 'Semester';
  final List<String> _filters = ['Weekly', 'Monthly', 'Semester', 'Year'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Filter Chips ──────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = f == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? AppTheme.strongShadow : AppTheme.cardShadow,
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── 1. Academic Progress Line Chart ───────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'Academic Progress'),
            const SizedBox(height: 12),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IA Performance Trend',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Average marks across assessments',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PerformanceLineChart(
                        examHistory: provider.examHistory),
                  ),
                ],
              ),
            ),

            // ── 2. Subject-wise Bar Chart ─────────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'Subject Performance'),
            const SizedBox(height: 12),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Marks by Subject',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Total percentage per subject',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: SubjectBarChart(
                        subjects: provider.subjectMarksList),
                  ),
                ],
              ),
            ),

            // ── 3. Attendance Donut ────────────────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'Attendance Overview'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Present vs Absent',
                            style:
                                Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: AttendanceDonutChart(
                            present: provider.totalPresentDays.toDouble(),
                            absent: (provider.totalClassDays -
                                    provider.totalPresentDays)
                                .toDouble(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _legendCard(
                        context,
                        color: AppTheme.success,
                        label: 'Present',
                        value: '${provider.totalPresentDays}',
                        pct: provider.overallAttendance,
                      ),
                      const SizedBox(height: 12),
                      _legendCard(
                        context,
                        color: AppTheme.danger,
                        label: 'Absent',
                        value:
                            '${provider.totalClassDays - provider.totalPresentDays}',
                        pct: 100 - provider.overallAttendance,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── 4. IA Comparison Chart ─────────────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'IA 1 vs IA 2 Comparison'),
            const SizedBox(height: 12),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assessment Comparison',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('IA 1 vs IA 2 subject-wise',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  ...provider.subjectMarksList.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _iaCompRow(context, s),
                      )),
                ],
              ),
            ),

            // ── 5. Monthly Attendance Trend ───────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'Monthly Attendance Trend'),
            const SizedBox(height: 12),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Month-wise Attendance',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: MonthlyTrendChart(
                        attendanceList: provider.attendanceList),
                  ),
                ],
              ),
            ),

            // ── Performance Summary ────────────────────────────
            const SizedBox(height: 20),
            const SectionHeader(title: 'Performance Summary'),
            const SizedBox(height: 12),
            _performanceSummaryGrid(context, provider),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _legendCard(
    BuildContext context, {
    required Color color,
    required String label,
    required String value,
    required double pct,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text('${pct.toStringAsFixed(1)}%',
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _iaCompRow(BuildContext context, SubjectMarks s) {
    final ia1Pct = s.ia1Marks / s.ia1Max;
    final ia2Pct = s.ia2Marks / s.ia2Max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.subjectName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Row(
          children: [
            const SizedBox(width: 40, child: Text('IA 1', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary))),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: ia1Pct,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  color: AppTheme.primary,
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${(ia1Pct * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const SizedBox(width: 40, child: Text('IA 2', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary))),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: ia2Pct,
                  backgroundColor: AppTheme.secondary.withOpacity(0.1),
                  color: AppTheme.secondary,
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${(ia2Pct * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 10, color: AppTheme.secondary, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _performanceSummaryGrid(BuildContext context, StudentProvider p) {
    final items = [
      {'label': 'Overall GPA', 'value': p.overallGrade, 'sub': '${p.overallPercentage.toStringAsFixed(1)}%', 'color': AppTheme.primary},
      {'label': 'Best Subject', 'value': p.highestScoringSubject.subjectName, 'sub': '${p.highestScoringSubject.percentage.toStringAsFixed(0)}%', 'color': AppTheme.success},
      {'label': 'Total Subjects', 'value': '${p.subjectMarksList.length}', 'sub': '${p.subjectsWithGoodPerformance} Good', 'color': AppTheme.secondary},
      {'label': 'Attendance', 'value': '${p.overallAttendance.toStringAsFixed(0)}%', 'sub': '${p.totalPresentDays}/${p.totalClassDays} days', 'color': AppTheme.accent},
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: items.map((item) {
        final color = item['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
            border: Border(left: BorderSide(color: color, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['label'] as String,
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary)),
              const SizedBox(height: 4),
              Text(item['value'] as String,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text(item['sub'] as String,
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
