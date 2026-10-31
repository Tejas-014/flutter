import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/gradient_card.dart';
import '../widgets/subject_bar_chart.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedSemester = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final subjects = provider.subjectMarksList;
    final highest = provider.highestScoringSubject;
    final lowest = provider.lowestScoringSubject;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Internal Marks'),
        backgroundColor: AppTheme.background,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedSemester,
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                items: List.generate(8, (i) => i + 1)
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text('Sem $s'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedSemester = v!),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary Banner ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.strongShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Internal Marks',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${provider.totalInternalMarks.toInt()} / ${provider.totalMaxMarks.toInt()}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Average: ${((provider.totalInternalMarks / provider.totalMaxMarks) * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      provider.overallGrade,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Top & Bottom ─────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _miniStat(
                    context,
                    label: '🏆 Highest',
                    subject: highest.subjectName,
                    value: '${highest.percentage.toStringAsFixed(1)}%',
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _miniStat(
                    context,
                    label: '⚠️ Lowest',
                    subject: lowest.subjectName,
                    value: '${lowest.percentage.toStringAsFixed(1)}%',
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ),

            // ── Subject Marks Chart ───────────────────────────
            const SizedBox(height: 24),
            const SectionHeader(title: 'Marks Comparison'),
            const SizedBox(height: 12),
            GradientCard(
              child: SizedBox(
                height: 180,
                child: SubjectBarChart(subjects: subjects),
              ),
            ),

            // ── Subject List ──────────────────────────────────
            const SizedBox(height: 24),
            const SectionHeader(title: 'Subject-wise Marks'),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _SubjectMarkCard(subject: subjects[index]);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(
    BuildContext context, {
    required String label,
    required String subject,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(subject,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _SubjectMarkCard extends StatelessWidget {
  final SubjectMarks subject;

  const _SubjectMarkCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(subject.percentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.subjectName,
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text(subject.subjectCode,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subject.grade,
                      style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${subject.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: subject.percentage / 100,
              backgroundColor: statusColor.withOpacity(0.15),
              color: statusColor,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 12),
          // Marks breakdown
          Row(
            children: [
              _markChip('IA 1', '${subject.ia1Marks.toInt()}/${subject.ia1Max.toInt()}', context),
              _markChip('IA 2', '${subject.ia2Marks.toInt()}/${subject.ia2Max.toInt()}', context),
              _markChip('Assign', '${subject.assignmentMarks.toInt()}/${subject.assignmentMax.toInt()}', context),
              _markChip('Quiz', '${subject.quizMarks.toInt()}/${subject.quizMax.toInt()}', context),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${subject.totalMarks.toInt()}/${subject.maxMarks.toInt()}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subject.performanceStatus,
                  style: TextStyle(
                      color: statusColor, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _markChip(String label, String value, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 80) return AppTheme.success;
    if (percentage >= 60) return AppTheme.warning;
    return AppTheme.danger;
  }
}
