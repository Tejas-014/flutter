import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final student = provider.student;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            student.avatarInitials,
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        student.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.rollNumber,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.department,
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
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () => _showEditProfileDialog(context, student),
                tooltip: 'Edit Profile',
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats Row ──────────────────────────────
                  Row(
                    children: [
                      _statCard(
                        context,
                        value: provider.overallGrade,
                        label: 'Grade',
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        context,
                        value: '${provider.overallPercentage.toStringAsFixed(0)}%',
                        label: 'Overall',
                        color: AppTheme.success,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        context,
                        value: '${provider.overallAttendance.toStringAsFixed(0)}%',
                        label: 'Attend.',
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        context,
                        value: '${provider.subjectMarksList.length}',
                        label: 'Subjects',
                        color: AppTheme.secondary,
                      ),
                    ],
                  ),

                  // ── Personal Info ──────────────────────────
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Personal Information'),
                  const SizedBox(height: 12),
                  GradientCard(
                    child: Column(
                      children: [
                        _infoRow(context,
                            icon: Icons.person_rounded,
                            label: 'Full Name',
                            value: student.name),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.badge_rounded,
                            label: 'Roll Number',
                            value: student.rollNumber),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.email_rounded,
                            label: 'Email',
                            value: student.email),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.school_rounded,
                            label: 'College',
                            value: student.collegeName),
                      ],
                    ),
                  ),

                  // ── Academic Info ──────────────────────────
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Academic Information'),
                  const SizedBox(height: 12),
                  GradientCard(
                    child: Column(
                      children: [
                        _infoRow(context,
                            icon: Icons.computer_rounded,
                            label: 'Department',
                            value: student.department),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.book_rounded,
                            label: 'Course',
                            value: student.course),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.calendar_today_rounded,
                            label: 'Year of Study',
                            value: 'Year ${student.yearOfStudy}'),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.format_list_numbered_rounded,
                            label: 'Current Semester',
                            value: 'Semester ${student.currentSemester}'),
                        _divider(),
                        _infoRow(context,
                            icon: Icons.date_range_rounded,
                            label: 'Academic Year',
                            value: student.academicYear),
                      ],
                    ),
                  ),

                  // ── Achievements ───────────────────────────
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Achievements'),
                  const SizedBox(height: 12),
                  _achievementsSection(context, provider),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFF0F0F0));

  Widget _achievementsSection(BuildContext context, StudentProvider provider) {
    final achievements = <Map<String, dynamic>>[];

    if (provider.overallPercentage >= 80) {
      achievements.add({
        'icon': Icons.emoji_events_rounded,
        'color': AppTheme.warning,
        'title': 'Academic Excellence',
        'desc': 'Maintained above 80% overall score',
      });
    }
    if (provider.overallAttendance >= 90) {
      achievements.add({
        'icon': Icons.verified_rounded,
        'color': AppTheme.success,
        'title': 'Perfect Attendance',
        'desc': 'Attendance above 90%',
      });
    }
    if (provider.highestScoringSubject.percentage >= 95) {
      achievements.add({
        'icon': Icons.star_rounded,
        'color': AppTheme.primary,
        'title': 'Subject Topper',
        'desc': 'Scored 95%+ in ${provider.highestScoringSubject.subjectName}',
      });
    }
    achievements.add({
      'icon': Icons.school_rounded,
      'color': AppTheme.secondary,
      'title': 'Semester 5 Enrolled',
      'desc': 'Successfully enrolled in Semester 5',
    });

    return Column(
      children: achievements
          .map((a) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (a['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(a['icon'] as IconData,
                          color: a['color'] as Color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(a['desc'] as String,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  void _showEditProfileDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile'),
        content: const Text(
          'Profile editing will be available in the next update with Firebase integration.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
