import 'package:flutter/foundation.dart';

import '../models/student_account.dart';

class AuthController extends ChangeNotifier {
  StudentAccount? _account = const StudentAccount(
    fullName: 'Meshva Barot',
    email: 'meshva.barot@example.com',
    mobile: '9876543210',
    password: 'Student@123',
    studentId: 'STU-2026-8942',
    department: 'Computer Science & Applications',
    status: 'Active Scholar',
  );

  bool _busy = false;

  StudentAccount? get account => _account;
  bool get isBusy => _busy;

  Future<String> register({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
  }) async {
    _busy = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));

    _account = StudentAccount(
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      mobile: mobile.trim(),
      password: password,
      studentId: 'STU-${DateTime.now().year}-${(1000 + DateTime.now().millisecond % 9000)}',
      department: 'Computer Science & Applications',
    );

    _busy = false;
    notifyListeners();
    return 'Registration successful! Welcome to the portal, ${_account!.fullName}.';
  }

  Future<String?> login({
    required String emailOrUsername,
    required String password,
  }) async {
    _busy = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final account = _account;
    final identifier = emailOrUsername.trim().toLowerCase();
    final valid = account != null &&
        (identifier == account.email ||
            identifier == account.fullName.toLowerCase()) &&
        password == account.password;

    _busy = false;
    notifyListeners();

    if (valid) {
      return 'Login successful! Welcome back, ${account.fullName}.';
    }
    return null;
  }

  void logout() {
    // Keep account in database/memory, but session terminates
    notifyListeners();
  }
}
