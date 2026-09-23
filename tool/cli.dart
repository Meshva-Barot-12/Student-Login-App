import 'dart:convert';
import 'dart:io';

import '../lib/core/validators.dart';
import '../lib/models/student_account.dart';

StudentAccount? account = const StudentAccount(
  fullName: 'Meshva Barot',
  email: 'meshva.barot@example.com',
  mobile: '9876543210',
  password: 'Student@123',
  studentId: 'STU-2026-8942',
  department: 'Computer Science & Applications',
);

void main() {
  stdout.writeln('\n=============================================');
  stdout.writeln('       STUDENT PORTAL — CLI CONSOLE          ');
  stdout.writeln('=============================================');
  stdout.writeln('Developer: Meshva Barot');
  stdout.writeln('Demo Account: meshva.barot@example.com / Student@123\n');

  while (true) {
    stdout.writeln('1. Login');
    stdout.writeln('2. Register New Student');
    stdout.writeln('3. View Student Profile');
    stdout.writeln('4. Exit');
    stdout.write('Select an option (1-4): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        _login();
      case '2':
        _register();
      case '3':
        _showAccount();
      case '4':
        stdout.writeln('\nSession terminated. Goodbye.');
        exit(0);
      default:
        stdout.writeln('Invalid choice. Please select 1, 2, 3, or 4.\n');
    }
  }
}

String _ask(String label) {
  stdout.write('$label: ');
  return stdin.readLineSync(encoding: utf8)?.trim() ?? '';
}

void _login() {
  final identifier = _ask('Email / Username');
  final password = _ask('Password');

  final identifierError = Validators.emailOrUsername(identifier);
  final passwordError = Validators.password(password);
  if (identifierError != null || passwordError != null) {
    stdout.writeln('\n[Validation Error] ${identifierError ?? passwordError}\n');
    return;
  }

  final current = account;
  final matches = current != null &&
      (identifier.toLowerCase() == current.email ||
          identifier.toLowerCase() == current.fullName.toLowerCase()) &&
      password == current.password;

  if (matches) {
    stdout.writeln('\n[SUCCESS] Login verified! Welcome back, ${current!.fullName}.');
    stdout.writeln('Student ID: ${current.studentId} | Department: ${current.department}\n');
  } else {
    stdout.writeln('\n[FAILED] Login credentials invalid. Please try again.\n');
  }
}

void _register() {
  final fullName = _ask('Full Name');
  final email = _ask('Email');
  final mobile = _ask('Mobile Number (10 digits)');
  final password = _ask('Password');
  final confirm = _ask('Confirm Password');

  final errors = <String>[
    if (Validators.required(fullName, field: 'Full Name') != null)
      Validators.required(fullName, field: 'Full Name')!,
    if (Validators.email(email) != null) Validators.email(email)!,
    if (Validators.mobile(mobile) != null) Validators.mobile(mobile)!,
    if (Validators.password(password) != null) Validators.password(password)!,
    if (Validators.confirmPassword(confirm, password) != null)
      Validators.confirmPassword(confirm, password)!,
  ];

  if (errors.isNotEmpty) {
    stdout.writeln('\n[Validation Error] ${errors.first}\n');
    return;
  }

  account = StudentAccount(
    fullName: fullName,
    email: email.toLowerCase(),
    mobile: mobile,
    password: password,
    studentId: 'STU-${DateTime.now().year}-${1000 + DateTime.now().millisecond % 9000}',
    department: 'Computer Science & Applications',
  );
  stdout.writeln('\n[SUCCESS] Registration complete! Welcome to the portal, $fullName.\n');
}

void _showAccount() {
  final current = account;
  if (current == null) {
    stdout.writeln('\nNo active student record registered.\n');
    return;
  }
  stdout.writeln('\n---------------------------------------------');
  stdout.writeln('            ACTIVE STUDENT PROFILE           ');
  stdout.writeln('---------------------------------------------');
  stdout.writeln('Name:       ${current.fullName}');
  stdout.writeln('Student ID: ${current.studentId}');
  stdout.writeln('Department: ${current.department}');
  stdout.writeln('Email:      ${current.email}');
  stdout.writeln('Mobile:     ${current.mobile}');
  stdout.writeln('Status:     ${current.status}');
  stdout.writeln('---------------------------------------------\n');
}
