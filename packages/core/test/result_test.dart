import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T>', () {
    test('Success folds to onSuccess', () {
      const Result<int> result = Success(42);
      expect(result.isSuccess, isTrue);
      expect(
        result.fold(onSuccess: (v) => v * 2, onFailure: (_) => 0),
        equals(84),
      );
    });

    test('Failure folds to onFailure', () {
      const Result<int> result = Failure(ValidationException('Invalid input'));
      expect(result.isFailure, isTrue);
      expect(
        result.fold(onSuccess: (v) => v, onFailure: (e) => -1),
        equals(-1),
      );
    });
  });
}
