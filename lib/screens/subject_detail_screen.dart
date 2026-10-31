import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';
import '../widgets/section_header.dart';
import '../widgets/ia_comparison_chart.dart';

class SubjectDetailScreen extends StatelessWidget {
  final SubjectMarks subject;
  final SubjectAttendance attendance;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final perfColor = _getColor(subject.percentage);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: perfColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [perfColor, perfColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              subject.subjectName[0],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(subject.subjectName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text(
                            '${subject.subjectCode}  •  ${subject.facultyName}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Performance Summary ────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          context,
                          label: 'Overall %',
                          value: '${subject.percentage.toStringAsFixed(1)}%',
                          color: perfColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _summaryCard(
                          context,
                          label: 'Grade',
                          value: subject.grade,
                          color: perfColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _summaryCard(
                          context,
                          label: 'Attendance',
                          value: '${attendance.percentage.toStringAsFixed(1)}%',
                          color: _getColor(attendance.percentage),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Marks Breakdown'),
                  const SizedBox(height: 12),

                  // ── Marks Breakdown ────────────────────────
                  GradientCard(
                    child: Column(
                      children: [
                        _markRow(
                          context,
                          label: 'Internal Assessment 1',
                          marks: subject.ia1Marks,
                          max: subject.ia1Max,
                          color: AppTheme.primary,
                        ),
                        const Divider(height: 20),
                        _markRow(
                          context,
                          label: 'Internal Assessment 2',
                          marks: subject.ia2Marks,
                          max: subject.ia2Max,
                          color: AppTheme.secondary,
                        ),
                        const Divider(height: 20),
                        _markRow(
                          context,
                          label: 'Assignment',
                          marks: subject.assignmentMarks,
                          max: subject.assignmentMax,
                          color: AppTheme.accent,
                        ),
                        const Divider(height: 20),
                        _markRow(
                          context,
                          label: 'Quiz',
                          marks: subject.quizMarks,
                          max: subject.quizMax,
                          color: AppTheme.warning,
                        ),
                        const Divider(height: 20),
                        _markRow(
                          context,
                          label: 'Total',
                          marks: subject.totalMarks,
                          max: subject.maxMarks,
                          color: perfColor,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  // ── IA Comparison Chart ────────────────────
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'IA Comparison'),
                  const SizedBox(height: 12),
                  GradientCard(
                    child: SizedBox(
                      height: 160,
                      child: IAComparisonChart(subject: subject),
                    ),
                  ),

                  // ── Attendance History ─────────────────────
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Attendance History'),
                  const SizedBox(height: 12),
                  GradientCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: attendance.monthlyRecords.map((rec) {
                            return Column(
                              children: [
                                CircularPercentIndicator(
                                  radius: 30,
                                  lineWidth: 5,
                                  percent: rec.percentage / 100,
                                  center: Text(
                                    '${rec.percentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: _getColor(rec.percentage),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  progressColor: _getColor(rec.percentage),
                                  backgroundColor:
                                      _getColor(rec.percentage).withOpacity(0.15),
                                  animation: true,
                                ),
                                const SizedBox(height: 6),
                                Text(rec.month,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                Text('${rec.presentDays}/${rec.totalDays}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary)),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // ── Strengths & Weaknesses ─────────────────
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Analysis'),
                  const SizedBox(height: 12),
                  _analysisSection(context),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _markRow(
    BuildContext context, {
    required String label,
    required double marks,
    required double max,
    required Color color,
    bool isBold = false,
  }) {
    final pct = marks / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary),
            ),
            Text(
              '${marks.toInt()} / ${max.toInt()}',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: color.withOpacity(0.15),
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _analysisSection(BuildContext context) {
    final strengths = _getStrengths();
    final suggestions = _getSuggestions();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.success.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.success.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.thumb_up_rounded,
                      color: AppTheme.success, size: 18),
                  SizedBox(width: 8),
                  Text('Strengths',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.success,
                          fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              ...strengths.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppTheme.success)),
                        Expanded(
                            child: Text(s,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textPrimary))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_rounded,
                      color: AppTheme.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Suggestions for Improvement',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                          fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              ...suggestions.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppTheme.primary)),
                        Expanded(
                            child: Text(s,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textPrimary))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _getStrengths() {
    final strengths = <String>[];
    if (subject.ia1Marks / subject.ia1Max >= 0.8) {
      strengths.add('Strong performance in Internal Assessment 1.');
    }
    if (subject.ia2Marks / subject.ia2Max >= 0.8) {
      strengths.add('Excellent score in Internal Assessment 2.');
    }
    if (subject.assignmentMarks / subject.assignmentMax >= 0.8) {
      strengths.add('Consistent assignment submission and quality.');
    }
    if (attendance.percentage >= 85) {
      strengths.add('Great attendance record for this subject.');
    }
    if (strengths.isEmpty) {
      strengths.add('Showing consistent effort in this subject.');
    }
    return strengths;
  }

  List<String> _getSuggestions() {
    final suggestions = <String>[];
    if (subject.ia1Marks / subject.ia1Max < 0.7) {
      suggestions.add('Review IA 1 topics and focus on weak areas.');
    }
    if (subject.ia2Marks / subject.ia2Max < 0.7) {
      suggestions.add('Practice more problems related to IA 2 syllabus.');
    }
    if (attendance.percentage < 75) {
      suggestions.add('Improve attendance to avoid shortage – currently below 75%.');
    }
    if (subject.quizMarks / subject.quizMax < 0.7) {
      suggestions.add('Revise quiz topics regularly for better quiz scores.');
    }
    if (suggestions.isEmpty) {
      suggestions.add('Keep up the great work! Aim for higher grades in upcoming assessments.');
      suggestions.add('Participate actively in classroom discussions.');
    }
    return suggestions;
  }

  Color _getColor(double percentage) {
    if (percentage >= 80) return AppTheme.success;
    if (percentage >= 60) return AppTheme.warning;
    return AppTheme.danger;
  }
}
