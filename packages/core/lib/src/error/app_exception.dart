sealed class AppException implements Exception {
  const AppException(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.cause, this.statusCode});
  final int? statusCode;
}

final class StorageException extends AppException {
  const StorageException(super.message, {super.code, super.cause});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.cause});
}
