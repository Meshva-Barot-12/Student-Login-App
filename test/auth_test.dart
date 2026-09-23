import 'package:flutter_test/flutter_test.dart';
import 'package:student_login_app/models/student_account.dart';
import 'package:student_login_app/state/auth_controller.dart';

void main() {
  group('AuthController & StudentAccount Tests', () {
    test('Default account belongs to Meshva Barot', () {
      final auth = AuthController();
      expect(auth.account, isNotNull);
      expect(auth.account!.fullName, 'Meshva Barot');
      expect(auth.account!.email, 'meshva.barot@example.com');
      expect(auth.account!.mobile, '9876543210');
      expect(auth.account!.studentId, 'STU-2026-8942');
    });

    test('Login with valid credentials succeeds', () async {
      final auth = AuthController();
      final result = await auth.login(
        emailOrUsername: 'meshva.barot@example.com',
        password: 'Student@123',
      );
      expect(result, isNotNull);
      expect(result, contains('Welcome back, Meshva Barot'));
    });

    test('Login with student name succeeds', () async {
      final auth = AuthController();
      final result = await auth.login(
        emailOrUsername: 'Meshva Barot',
        password: 'Student@123',
      );
      expect(result, isNotNull);
      expect(result, contains('Welcome back, Meshva Barot'));
    });

    test('Login with invalid credentials fails', () async {
      final auth = AuthController();
      final result = await auth.login(
        emailOrUsername: 'meshva.barot@example.com',
        password: 'WrongPassword',
      );
      expect(result, isNull);
    });

    test('Registration creates new student account', () async {
      final auth = AuthController();
      final result = await auth.register(
        fullName: 'New Scholar',
        email: 'scholar@example.com',
        mobile: '9123456780',
        password: 'Password@123',
      );
      expect(result, contains('Registration successful!'));
      expect(auth.account!.fullName, 'New Scholar');
      expect(auth.account!.email, 'scholar@example.com');
    });
  });
}
