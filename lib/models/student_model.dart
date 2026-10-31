// Models for Student Academic Progress Tracker
import 'package:flutter/foundation.dart';
import '../data/sample_data.dart';

class Student {
  final String name;
  final String rollNumber;
  final String department;
  final String course;
  final int yearOfStudy;
  final int currentSemester;
  final String academicYear;
  final String collegeName;
  final String email;
  final String avatarInitials;

  const Student({
    required this.name,
    required this.rollNumber,
    required this.department,
    required this.course,
    required this.yearOfStudy,
    required this.currentSemester,
    required this.academicYear,
    required this.collegeName,
    required this.email,
    required this.avatarInitials,
  });
}

class SubjectMarks {
  final String subjectName;
  final String subjectCode;
  final String facultyName;
  final double ia1Marks;
  final double ia1Max;
  final double ia2Marks;
  final double ia2Max;
  final double assignmentMarks;
  final double assignmentMax;
  final double quizMarks;
  final double quizMax;

  const SubjectMarks({
    required this.subjectName,
    required this.subjectCode,
    required this.facultyName,
    required this.ia1Marks,
    this.ia1Max = 20,
    required this.ia2Marks,
    this.ia2Max = 20,
    required this.assignmentMarks,
    this.assignmentMax = 10,
    required this.quizMarks,
    this.quizMax = 10,
  });

  double get totalMarks => ia1Marks + ia2Marks + assignmentMarks + quizMarks;
  double get maxMarks => ia1Max + ia2Max + assignmentMax + quizMax;
  double get percentage => (totalMarks / maxMarks) * 100;

  String get grade {
    final p = percentage;
    if (p >= 90) return 'O';
    if (p >= 80) return 'A+';
    if (p >= 70) return 'A';
    if (p >= 60) return 'B+';
    if (p >= 50) return 'B';
    return 'C';
  }

  String get performanceStatus {
    final p = percentage;
    if (p >= 90) return 'Excellent';
    if (p >= 80) return 'Very Good';
    if (p >= 70) return 'Good';
    if (p >= 60) return 'Average';
    return 'Needs Improvement';
  }
}

class SubjectAttendance {
  final String subjectName;
  final String subjectCode;
  final int presentDays;
  final int totalClasses;
  final List<AttendanceRecord> monthlyRecords;

  const SubjectAttendance({
    required this.subjectName,
    required this.subjectCode,
    required this.presentDays,
    required this.totalClasses,
    this.monthlyRecords = const [],
  });

  double get percentage => (presentDays / totalClasses) * 100;
  int get absentDays => totalClasses - presentDays;

  String get status {
    if (percentage >= 85) return 'Good';
    if (percentage >= 75) return 'Average';
    return 'Low';
  }

  int get classesNeededFor75 {
    // Calculate additional classes needed to reach 75%
    if (percentage >= 75) return 0;
    // (present + x) / (total + x) >= 0.75
    // present + x >= 0.75 * total + 0.75x
    // 0.25x >= 0.75 * total - present
    double needed = (0.75 * totalClasses - presentDays) / 0.25;
    return needed.ceil();
  }
}

class AttendanceRecord {
  final String month;
  final int presentDays;
  final int totalDays;

  const AttendanceRecord({
    required this.month,
    required this.presentDays,
    required this.totalDays,
  });

  double get percentage => (presentDays / totalDays) * 100;
}

class ExamHistory {
  final String examName;
  final Map<String, double> subjectMarks; // subjectName -> marks%

  const ExamHistory({
    required this.examName,
    required this.subjectMarks,
  });

  double get average {
    if (subjectMarks.isEmpty) return 0;
    return subjectMarks.values.reduce((a, b) => a + b) / subjectMarks.length;
  }
}

class CalendarDay {
  final DateTime date;
  final bool isPresent;
  final bool isHoliday;

  const CalendarDay({
    required this.date,
    required this.isPresent,
    this.isHoliday = false,
  });
}

// Provider / State Management
class StudentProvider extends ChangeNotifier {
  Student get student => SampleData.student;
  List<SubjectMarks> get subjectMarksList => SampleData.subjectMarksList;
  List<SubjectAttendance> get attendanceList => SampleData.attendanceList;
  List<ExamHistory> get examHistory => SampleData.examHistory;

  int _selectedSemester = 5;
  int get selectedSemester => _selectedSemester;

  String _analyticsFilter = 'Semester';
  String get analyticsFilter => _analyticsFilter;

  void setSemester(int semester) {
    _selectedSemester = semester;
    notifyListeners();
  }

  void setAnalyticsFilter(String filter) {
    _analyticsFilter = filter;
    notifyListeners();
  }

  double get overallPercentage {
    if (subjectMarksList.isEmpty) return 0;
    return subjectMarksList.map((s) => s.percentage).reduce((a, b) => a + b) /
        subjectMarksList.length;
  }

  double get overallAttendance {
    if (attendanceList.isEmpty) return 0;
    int totalPresent = attendanceList.map((a) => a.presentDays).reduce((a, b) => a + b);
    int totalClasses = attendanceList.map((a) => a.totalClasses).reduce((a, b) => a + b);
    return (totalPresent / totalClasses) * 100;
  }

  int get totalPresentDays {
    return attendanceList.map((a) => a.presentDays).reduce((a, b) => a + b);
  }

  int get totalClassDays {
    return attendanceList.map((a) => a.totalClasses).reduce((a, b) => a + b);
  }

  SubjectMarks get highestScoringSubject {
    return subjectMarksList.reduce((a, b) => a.percentage > b.percentage ? a : b);
  }

  SubjectMarks get lowestScoringSubject {
    return subjectMarksList.reduce((a, b) => a.percentage < b.percentage ? a : b);
  }

  String get overallGrade {
    final p = overallPercentage;
    if (p >= 90) return 'O';
    if (p >= 80) return 'A+';
    if (p >= 70) return 'A';
    if (p >= 60) return 'B+';
    if (p >= 50) return 'B';
    return 'C';
  }

  int get subjectsNeedingImprovement {
    return subjectMarksList.where((s) => s.percentage < 70).length;
  }

  int get subjectsWithGoodPerformance {
    return subjectMarksList.where((s) => s.percentage >= 70).length;
  }

  double get totalInternalMarks {
    return subjectMarksList.map((s) => s.totalMarks).reduce((a, b) => a + b);
  }

  double get totalMaxMarks {
    return subjectMarksList.map((s) => s.maxMarks).reduce((a, b) => a + b);
  }
}
