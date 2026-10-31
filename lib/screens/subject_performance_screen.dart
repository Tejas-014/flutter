import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import 'subject_detail_screen.dart';

class SubjectPerformanceScreen extends StatelessWidget {
  const SubjectPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final subjects = provider.subjectMarksList;
    final attendanceList = provider.attendanceList;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Subject Performance'),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'All Subjects'),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final subj = subjects[index];
                final att = attendanceList.firstWhere(
                  (a) => a.subjectCode == subj.subjectCode,
                  orElse: () => attendanceList[index],
                );
                return _SubjectPerformanceCard(
                  subject: subj,
                  attendance: att,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectDetailScreen(
                        subject: subj,
                        attendance: att,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SubjectPerformanceCard extends StatelessWidget {
  final SubjectMarks subject;
  final SubjectAttendance attendance;
  final VoidCallback onTap;

  const _SubjectPerformanceCard({
    required this.subject,
    required this.attendance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final perfColor = _getPerfColor(subject.percentage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      subject.subjectName[0],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject.subjectName,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text(subject.subjectCode,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary)),
                      Text('Faculty: ${subject.facultyName}',
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: perfColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        subject.grade,
                        style: TextStyle(
                            color: perfColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppTheme.textSecondary),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats row
            Row(
              children: [
                _statItem(
                  context,
                  icon: Icons.assignment_rounded,
                  color: AppTheme.primary,
                  label: 'IA 1',
                  value:
                      '${subject.ia1Marks.toInt()}/${subject.ia1Max.toInt()}',
                ),
                _statItem(
                  context,
                  icon: Icons.assignment_outlined,
                  color: AppTheme.secondary,
                  label: 'IA 2',
                  value:
                      '${subject.ia2Marks.toInt()}/${subject.ia2Max.toInt()}',
                ),
                _statItem(
                  context,
                  icon: Icons.task_rounded,
                  color: AppTheme.accent,
                  label: 'Assign',
                  value:
                      '${subject.assignmentMarks.toInt()}/${subject.assignmentMax.toInt()}',
                ),
                _statItem(
                  context,
                  icon: Icons.calendar_month_rounded,
                  color: AppTheme.success,
                  label: 'Attend',
                  value: '${attendance.percentage.toStringAsFixed(0)}%',
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Progress bar + status
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: subject.percentage / 100,
                      backgroundColor: perfColor.withOpacity(0.15),
                      color: perfColor,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${subject.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                      color: perfColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: perfColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subject.performanceStatus,
                style: TextStyle(
                    color: perfColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _getPerfColor(double percentage) {
    if (percentage >= 80) return AppTheme.success;
    if (percentage >= 60) return AppTheme.warning;
    return AppTheme.danger;
  }
}
