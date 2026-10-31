import '../models/student_model.dart';

class SampleData {
  // ── Student ──────────────────────────────────────────────────
  static const Student student = Student(
    name: 'Rahul Kumar',
    rollNumber: '22CS045',
    department: 'Computer Science',
    course: 'B.Tech',
    yearOfStudy: 3,
    currentSemester: 5,
    academicYear: '2026–2027',
    collegeName: 'National Institute of Technology',
    email: 'rahul.kumar@nit.ac.in',
    avatarInitials: 'RK',
  );

  // ── Internal Marks ───────────────────────────────────────────
  static const List<SubjectMarks> subjectMarksList = [
    SubjectMarks(
      subjectName: 'Mathematics',
      subjectCode: 'MA301',
      facultyName: 'Dr. Priya Sharma',
      ia1Marks: 18,
      ia2Marks: 16,
      assignmentMarks: 9,
      quizMarks: 8,
    ),
    SubjectMarks(
      subjectName: 'Physics',
      subjectCode: 'PH301',
      facultyName: 'Prof. Anil Verma',
      ia1Marks: 17,
      ia2Marks: 18,
      assignmentMarks: 8,
      quizMarks: 7,
    ),
    SubjectMarks(
      subjectName: 'Programming',
      subjectCode: 'CS301',
      facultyName: 'Dr. Meena Gupta',
      ia1Marks: 19,
      ia2Marks: 18,
      assignmentMarks: 10,
      quizMarks: 9,
    ),
    SubjectMarks(
      subjectName: 'Chemistry',
      subjectCode: 'CH301',
      facultyName: 'Prof. Rajesh Nair',
      ia1Marks: 15,
      ia2Marks: 16,
      assignmentMarks: 8,
      quizMarks: 6,
    ),
    SubjectMarks(
      subjectName: 'Data Structures',
      subjectCode: 'CS302',
      facultyName: 'Dr. Sunita Patel',
      ia1Marks: 20,
      ia2Marks: 19,
      assignmentMarks: 10,
      quizMarks: 10,
    ),
  ];

  // ── Attendance ───────────────────────────────────────────────
  static const List<SubjectAttendance> attendanceList = [
    SubjectAttendance(
      subjectName: 'Mathematics',
      subjectCode: 'MA301',
      presentDays: 38,
      totalClasses: 40,
      monthlyRecords: [
        AttendanceRecord(month: 'Jul', presentDays: 10, totalDays: 10),
        AttendanceRecord(month: 'Aug', presentDays: 12, totalDays: 14),
        AttendanceRecord(month: 'Sep', presentDays: 9, totalDays: 10),
        AttendanceRecord(month: 'Oct', presentDays: 7, totalDays: 6),
      ],
    ),
    SubjectAttendance(
      subjectName: 'Physics',
      subjectCode: 'PH301',
      presentDays: 34,
      totalClasses: 40,
      monthlyRecords: [
        AttendanceRecord(month: 'Jul', presentDays: 9, totalDays: 10),
        AttendanceRecord(month: 'Aug', presentDays: 11, totalDays: 14),
        AttendanceRecord(month: 'Sep', presentDays: 8, totalDays: 10),
        AttendanceRecord(month: 'Oct', presentDays: 6, totalDays: 6),
      ],
    ),
    SubjectAttendance(
      subjectName: 'Programming',
      subjectCode: 'CS301',
      presentDays: 36,
      totalClasses: 40,
      monthlyRecords: [
        AttendanceRecord(month: 'Jul', presentDays: 10, totalDays: 10),
        AttendanceRecord(month: 'Aug', presentDays: 13, totalDays: 14),
        AttendanceRecord(month: 'Sep', presentDays: 7, totalDays: 10),
        AttendanceRecord(month: 'Oct', presentDays: 6, totalDays: 6),
      ],
    ),
    SubjectAttendance(
      subjectName: 'Chemistry',
      subjectCode: 'CH301',
      presentDays: 29,
      totalClasses: 40,
      monthlyRecords: [
        AttendanceRecord(month: 'Jul', presentDays: 7, totalDays: 10),
        AttendanceRecord(month: 'Aug', presentDays: 10, totalDays: 14),
        AttendanceRecord(month: 'Sep', presentDays: 7, totalDays: 10),
        AttendanceRecord(month: 'Oct', presentDays: 5, totalDays: 6),
      ],
    ),
    SubjectAttendance(
      subjectName: 'Data Structures',
      subjectCode: 'CS302',
      presentDays: 39,
      totalClasses: 40,
      monthlyRecords: [
        AttendanceRecord(month: 'Jul', presentDays: 10, totalDays: 10),
        AttendanceRecord(month: 'Aug', presentDays: 14, totalDays: 14),
        AttendanceRecord(month: 'Sep', presentDays: 9, totalDays: 10),
        AttendanceRecord(month: 'Oct', presentDays: 6, totalDays: 6),
      ],
    ),
  ];

  // ── Exam History ─────────────────────────────────────────────
  static const List<ExamHistory> examHistory = [
    ExamHistory(
      examName: 'IA 1',
      subjectMarks: {
        'Mathematics': 90.0,
        'Physics': 85.0,
        'Programming': 95.0,
        'Chemistry': 75.0,
        'Data Structures': 100.0,
      },
    ),
    ExamHistory(
      examName: 'IA 2',
      subjectMarks: {
        'Mathematics': 80.0,
        'Physics': 90.0,
        'Programming': 90.0,
        'Chemistry': 80.0,
        'Data Structures': 95.0,
      },
    ),
  ];

  // ── Calendar days for October 2026 (sample) ──────────────────
  static List<CalendarDay> get octoberCalendar {
    final days = <CalendarDay>[];
    // Weekdays in October 2026 present/absent pattern
    final presentDates = [1, 2, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 26, 27, 28];
    final holidays = [3, 4, 10, 11, 17, 18, 24, 25, 31]; // weekends
    for (int d = 1; d <= 31; d++) {
      final date = DateTime(2026, 10, d);
      if (holidays.contains(d)) {
        days.add(CalendarDay(date: date, isPresent: false, isHoliday: true));
      } else if (presentDates.contains(d)) {
        days.add(CalendarDay(date: date, isPresent: true));
      } else {
        days.add(CalendarDay(date: date, isPresent: false));
      }
    }
    return days;
  }
}
