import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/overview_card.dart';
import '../widgets/gradient_card.dart';
import '../widgets/section_header.dart';
import '../widgets/quick_nav_card.dart';
import '../widgets/performance_line_chart.dart';
import '../widgets/subject_bar_chart.dart';
import 'marks_screen.dart';
import 'attendance_screen.dart';
import 'subject_performance_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final student = provider.student;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar / Header ────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, Student! 👋',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _iconBtn(Icons.notifications_outlined, context),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white24,
                                  child: Text(
                                    student.avatarInitials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Semester ${student.currentSemester}  •  ${student.academicYear}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
                  // ── Overview Cards Row ────────────────────────
                  const SectionHeader(title: 'Academic Overview'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.0,
                    children: [
                      OverviewCard(
                        title: 'Performance',
                        value:
                            '${provider.overallPercentage.toStringAsFixed(1)}%',
                        subtitle: 'Grade: ${provider.overallGrade}',
                        icon: Icons.emoji_events_rounded,
                        gradient: AppTheme.primaryGradient,
                        progress: provider.overallPercentage / 100,
                      ),
                      OverviewCard(
                        title: 'Attendance',
                        value:
                            '${provider.overallAttendance.toStringAsFixed(1)}%',
                        subtitle:
                            '${provider.totalPresentDays}P / ${provider.totalClassDays - provider.totalPresentDays}A',
                        icon: Icons.check_circle_rounded,
                        gradient: AppTheme.successGradient,
                        progress: provider.overallAttendance / 100,
                      ),
                      OverviewCard(
                        title: 'Internal Marks',
                        value:
                            '${provider.totalInternalMarks.toInt()}/${provider.totalMaxMarks.toInt()}',
                        subtitle:
                            '${((provider.totalInternalMarks / provider.totalMaxMarks) * 100).toStringAsFixed(1)}% avg',
                        icon: Icons.assignment_turned_in_rounded,
                        gradient: AppTheme.accentGradient,
                        progress: provider.totalInternalMarks /
                            provider.totalMaxMarks,
                      ),
                      OverviewCard(
                        title: 'Subjects',
                        value: '${provider.subjectMarksList.length}',
                        subtitle:
                            '${provider.subjectsWithGoodPerformance} Good • ${provider.subjectsNeedingImprovement} Need ↑',
                        icon: Icons.book_rounded,
                        gradient: AppTheme.warningGradient,
                        progress: provider.subjectsWithGoodPerformance /
                            provider.subjectMarksList.length,
                      ),
                    ],
                  ),

                  // ── Performance Chart ─────────────────────────
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Academic Progress'),
                  const SizedBox(height: 12),
                  GradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IA Progress',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall),
                        const SizedBox(height: 4),
                        Text('Average marks across assessments',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: PerformanceLineChart(
                              examHistory: provider.examHistory),
                        ),
                      ],
                    ),
                  ),

                  // ── Subject Bar Chart ─────────────────────────
                  const SizedBox(height: 16),
                  GradientCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject Performance',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall),
                        const SizedBox(height: 4),
                        Text('Marks percentage by subject',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: SubjectBarChart(
                              subjects: provider.subjectMarksList),
                        ),
                      ],
                    ),
                  ),

                  // ── Quick Navigation ──────────────────────────
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Quick Access'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    childAspectRatio: 1.5,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      QuickNavCard(
                        icon: Icons.calendar_month_rounded,
                        label: 'Attendance',
                        color: AppTheme.success,
                        onTap: () => _navigate(context, 2),
                      ),
                      QuickNavCard(
                        icon: Icons.assignment_rounded,
                        label: 'Internal Marks',
                        color: AppTheme.primary,
                        onTap: () => _navigate(context, 1),
                      ),
                      QuickNavCard(
                        icon: Icons.school_rounded,
                        label: 'Subject Performance',
                        color: AppTheme.secondary,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SubjectPerformanceScreen(),
                          ),
                        ),
                      ),
                      QuickNavCard(
                        icon: Icons.bar_chart_rounded,
                        label: 'Analytics',
                        color: AppTheme.warning,
                        onTap: () => _navigate(context, 3),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Highlight cards ───────────────────────────
                  const SectionHeader(title: 'Highlights'),
                  const SizedBox(height: 12),
                  _highlightCard(
                    context,
                    icon: Icons.trending_up_rounded,
                    iconColor: AppTheme.success,
                    title: '🏆 Top Subject',
                    subtitle: provider.highestScoringSubject.subjectName,
                    value:
                        '${provider.highestScoringSubject.percentage.toStringAsFixed(1)}%',
                    valueColor: AppTheme.success,
                  ),
                  const SizedBox(height: 10),
                  _highlightCard(
                    context,
                    icon: Icons.warning_rounded,
                    iconColor: AppTheme.danger,
                    title: '⚠️ Needs Attention',
                    subtitle: provider.lowestScoringSubject.subjectName,
                    value:
                        '${provider.lowestScoringSubject.percentage.toStringAsFixed(1)}%',
                    valueColor: AppTheme.danger,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _highlightCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.textSecondary)),
                Text(subtitle,
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    Widget target;
    switch (index) {
      case 1:
        target = const MarksScreen();
        break;
      case 2:
        target = const AttendanceScreen();
        break;
      case 3:
        target = const AnalyticsScreen();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => target));
  }
}
