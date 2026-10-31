# Student Academic Progress Tracker 🎓

A modern, feature-rich Flutter mobile application for tracking student academic performance with beautiful Material Design 3 UI.

---

## ✨ Features

### 📊 Dashboard
- Welcome header with student name, semester & academic year
- 4 Academic Overview cards (Performance, Attendance, Marks, Subjects)
- Interactive line chart for academic progress across IAs
- Subject-wise bar chart comparison
- Quick navigation to all major sections
- Highlights for top and weakest subjects

### 📝 Internal Marks Screen
- Subject-wise marks breakdown (IA 1, IA 2, Assignment, Quiz)
- Auto-calculated percentage and grade
- Performance status with color-coded indicators
- Semester filter
- Highest / Lowest scoring subject highlights
- Marks comparison bar chart

### 📅 Attendance Tracking Screen
- Overall attendance summary with circular progress
- Subject-wise attendance with individual circular indicators
- **Color coding:** 🟢 ≥85% | 🟡 75–84% | 🔴 <75%
- Attendance donut chart (Present vs Absent)
- Monthly attendance trend line chart
- ⚠️ Low attendance warnings with classes-needed calculator
- Interactive monthly calendar with present/absent/holiday markers

### 🏫 Subject Performance Screen
- Rich subject cards with faculty, code, marks, attendance
- Grade and performance status badges
- Progress indicators per subject
- Tap to navigate to detailed subject analysis

### 🔍 Subject Detail Screen
- Full marks breakdown with progress bars
- Monthly attendance history with circular indicators
- IA 1 vs IA 2 comparison bar chart
- AI-generated Strengths and Suggestions

### 📈 Analytics Screen
- Filter: Weekly / Monthly / Semester / Year
- Academic Progress Line Chart
- Subject Performance Bar Chart
- Attendance Donut Chart with legend
- IA 1 vs IA 2 comparison (all subjects)
- Monthly Attendance Trend line chart
- Performance Summary grid

### 👤 Profile Screen
- Student avatar with gradient header
- Quick stats (Grade, Overall %, Attendance, Subjects)
- Personal & Academic information cards
- Achievements section
- Edit profile dialog (Firebase-ready)

---

## 📦 Technology Stack

| Tech | Package |
|------|---------|
| Framework | Flutter + Dart |
| Design | Material Design 3 |
| Charts | fl_chart ^0.68.0 |
| Typography | google_fonts ^6.2.1 |
| Progress | percent_indicator ^4.2.3 |
| Calendar | table_calendar ^3.1.2 |
| State Mgmt | provider ^6.1.2 |

---

## 🎨 Color Palette

| Color | Hex |
|-------|-----|
| Primary | `#4F46E5` |
| Secondary | `#7C3AED` |
| Background | `#F5F6FA` |
| Success | `#16A34A` |
| Warning | `#F59E0B` |
| Danger | `#DC2626` |
| Card | `#FFFFFF` |

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point
├── theme/
│   └── app_theme.dart           # Colors, typography, theme
├── models/
│   └── student_model.dart       # Data models + Provider
├── data/
│   └── sample_data.dart         # Realistic dummy data
├── screens/
│   ├── main_navigation_screen.dart  # Bottom nav
│   ├── home_screen.dart             # Dashboard
│   ├── marks_screen.dart            # Internal marks
│   ├── attendance_screen.dart       # Attendance tracking
│   ├── subject_performance_screen.dart  # Subject cards
│   ├── subject_detail_screen.dart       # Deep subject analysis
│   ├── analytics_screen.dart            # Charts & analytics
│   └── profile_screen.dart              # Student profile
└── widgets/
    ├── overview_card.dart          # Gradient stat card
    ├── gradient_card.dart          # White container card
    ├── section_header.dart         # Section titles
    ├── quick_nav_card.dart         # Navigation buttons
    ├── performance_line_chart.dart # IA progress chart
    ├── subject_bar_chart.dart      # Subject comparison chart
    ├── attendance_donut_chart.dart # Present/Absent donut
    ├── monthly_trend_chart.dart    # Monthly attendance trend
    └── ia_comparison_chart.dart    # IA 1 vs IA 2 chart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android Studio / VS Code with Flutter plugin

### Installation

```bash
# 1. Navigate to project directory
cd "D:\flutter project\student_tracker"

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 👨‍🎓 Sample Student Data

| Field | Value |
|-------|-------|
| Name | Rahul Kumar |
| Roll No | 22CS045 |
| Department | Computer Science |
| Course | B.Tech |
| Semester | 5 |
| Academic Year | 2026–2027 |
| College | National Institute of Technology |

### Subjects & Marks

| Subject | IA 1 | IA 2 | Assign | Quiz | Total | % |
|---------|------|------|--------|------|-------|---|
| Mathematics | 18/20 | 16/20 | 9/10 | 8/10 | 51/60 | 85.0% |
| Physics | 17/20 | 18/20 | 8/10 | 7/10 | 50/60 | 83.3% |
| Programming | 19/20 | 18/20 | 10/10 | 9/10 | 56/60 | 93.3% |
| Chemistry | 15/20 | 16/20 | 8/10 | 6/10 | 45/60 | 75.0% |
| Data Structures | 20/20 | 19/20 | 10/10 | 10/10 | 59/60 | 98.3% |

### Attendance

| Subject | Present | Total | % |
|---------|---------|-------|---|
| Mathematics | 38 | 40 | 95.0% |
| Physics | 34 | 40 | 85.0% |
| Programming | 36 | 40 | 90.0% |
| Chemistry | 29 | 40 | 72.5% ⚠️ |
| Data Structures | 39 | 40 | 97.5% |

---

## 🔮 Future Enhancements

- [ ] Firebase Authentication & Firestore integration
- [ ] REST API support for live college data
- [ ] Push notifications for low attendance warnings
- [ ] Dark mode support
- [ ] Export report as PDF
- [ ] Semester-wise historical data
- [ ] Grade prediction with ML

---

> **Note:** This is a UI demonstration with sample data. All student records are fictional and for showcase purposes only.
