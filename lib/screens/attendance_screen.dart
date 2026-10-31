import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/gradient_card.dart';
import '../widgets/attendance_donut_chart.dart';
import '../widgets/monthly_trend_chart.dart';
import '../data/sample_data.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _focusedDay = DateTime(2026, 10);
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final attendanceList = provider.attendanceList;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Attendance Tracking'),
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Overall Summary Banner ─────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.successGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.strongShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Overall Attendance',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          '${provider.overallAttendance.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _statPill(
                                '${provider.totalPresentDays}', 'Present',
                                Colors.white70),
                            const SizedBox(width: 12),
                            _statPill(
                                '${provider.totalClassDays - provider.totalPresentDays}',
                                'Absent',
                                Colors.white70),
                            const SizedBox(width: 12),
                            _statPill('${provider.totalClassDays}', 'Total',
                                Colors.white70),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 50,
                    lineWidth: 8,
                    percent: provider.overallAttendance / 100,
                    center: Text(
                      '${provider.overallAttendance.toStringAsFixed(0)}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white30,
                    animation: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Low attendance warnings ────────────────────────
            ...attendanceList
                .where((a) => a.percentage < 75)
                .map((a) => _warningBanner(context, a)),

            // ── Donut + Trend Charts ───────────────────────────
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GradientCard(
                    child: Column(
                      children: [
                        Text('Distribution',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
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
                  child: GradientCard(
                    child: Column(
                      children: [
                        Text('Monthly Trend',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: MonthlyTrendChart(
                              attendanceList: attendanceList),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Subject-wise Attendance ────────────────────────
            const SizedBox(height: 24),
            const SectionHeader(title: 'Subject-wise Attendance'),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attendanceList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _AttendanceCard(attendance: attendanceList[index]);
              },
            ),

            // ── Calendar ───────────────────────────────────────
            const SizedBox(height: 24),
            const SectionHeader(title: 'Monthly Calendar'),
            const SizedBox(height: 12),
            GradientCard(
              child: _buildCalendar(),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final calendarDays = SampleData.octoberCalendar;
    final presentDates =
        calendarDays.where((d) => d.isPresent).map((d) => d.date).toSet();
    final absentDates = calendarDays
        .where((d) => !d.isPresent && !d.isHoliday)
        .map((d) => d.date)
        .toSet();

    bool isSameDay2(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    return TableCalendar(
      firstDay: DateTime(2026, 7),
      lastDay: DateTime(2027, 5),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) =>
          _selectedDay != null && isSameDay2(day, _selectedDay!),
      onDaySelected: (selected, focused) {
        setState(() {
          _selectedDay = selected;
          _focusedDay = focused;
        });
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final isPresent =
              presentDates.any((d) => isSameDay2(d, day));
          final isAbsent = absentDates.any((d) => isSameDay2(d, day));
          if (isPresent) {
            return _calCell(day.day.toString(), AppTheme.success);
          } else if (isAbsent) {
            return _calCell(day.day.toString(), AppTheme.danger);
          }
          return null;
        },
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppTheme.secondary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _calCell(String text, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: color, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _statPill(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }

  Widget _warningBanner(BuildContext context, SubjectAttendance a) {
    final needed = a.classesNeededFor75;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_rounded, color: AppTheme.danger, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${a.subjectName} – Low Attendance',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.danger,
                      fontSize: 13),
                ),
                Text(
                  needed > 0
                      ? 'Attend $needed more consecutive classes to reach 75%'
                      : 'Attendance below 75% threshold',
                  style: const TextStyle(fontSize: 12, color: AppTheme.danger),
                ),
              ],
            ),
          ),
          Text(
            '${a.percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
                color: AppTheme.danger,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final SubjectAttendance attendance;

  const _AttendanceCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(attendance.percentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 32,
            lineWidth: 6,
            percent: attendance.percentage / 100,
            center: Text(
              '${attendance.percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 11),
            ),
            progressColor: color,
            backgroundColor: color.withOpacity(0.15),
            animation: true,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(attendance.subjectName,
                    style: Theme.of(context).textTheme.headlineSmall),
                Text(attendance.subjectCode,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _badge('${attendance.presentDays} Present',
                        AppTheme.success),
                    const SizedBox(width: 8),
                    _badge('${attendance.absentDays} Absent', AppTheme.danger),
                    const SizedBox(width: 8),
                    _badge('${attendance.totalClasses} Total',
                        AppTheme.textSecondary),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              attendance.status,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }

  Color _getColor(double percentage) {
    if (percentage >= 85) return AppTheme.success;
    if (percentage >= 75) return AppTheme.warning;
    return AppTheme.danger;
  }
}
