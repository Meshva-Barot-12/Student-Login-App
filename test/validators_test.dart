import 'package:flutter_test/flutter_test.dart';
import 'package:student_login_app/core/validators.dart';

void main() {
  test('email validates correctly', () {
    expect(Validators.email('student@example.com'), isNull);
    expect(Validators.email('invalid'), isNotNull);
  });

  test('mobile requires ten digits', () {
    expect(Validators.mobile('9876543210'), isNull);
    expect(Validators.mobile('12345'), isNotNull);
  });

  test('confirm password must match', () {
    expect(Validators.confirmPassword('abc123', 'abc123'), isNull);
    expect(Validators.confirmPassword('abc321', 'abc123'), isNotNull);
  });
}
