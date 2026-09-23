class StudentAccount {
  final String fullName;
  final String email;
  final String mobile;
  final String password;
  final String studentId;
  final String department;
  final String status;

  const StudentAccount({
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.password,
    this.studentId = 'STU-2026-8942',
    this.department = 'Computer Science & Applications',
    this.status = 'Active Scholar',
  });

  StudentAccount copyWith({
    String? fullName,
    String? email,
    String? mobile,
    String? password,
    String? studentId,
    String? department,
    String? status,
  }) {
    return StudentAccount(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      status: status ?? this.status,
    );
  }
}
