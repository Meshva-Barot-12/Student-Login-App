import 'package:flutter_test/flutter_test.dart';
import 'package:student_login_app/main.dart';

void main() {
  testWidgets('App smoke test loads LoginScreen without compilation errors', (tester) async {
    await tester.pumpWidget(const StudentLoginApp());
    expect(find.text('Student Portal'), findsWidgets);
  });
}
