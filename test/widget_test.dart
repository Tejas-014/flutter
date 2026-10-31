import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:student_tracker/main.dart';
import 'package:student_tracker/models/student_model.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StudentProvider()),
        ],
        child: const StudentTrackerApp(),
      ),
    );

    // Verify basic dashboard elements render
    expect(find.textContaining('Hello, Student!'), findsOneWidget);
  });
}
