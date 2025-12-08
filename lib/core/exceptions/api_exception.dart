class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic details;

  ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException: $message (Code: $code, Status: $statusCode)';
  }

  factory ApiException.fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      final error = response['error'] as Map<String, dynamic>?;
      return ApiException(
        message: error?['message'] as String? ?? 'Unknown error occurred',
        code: error?['code'] as String?,
        statusCode: response['statusCode'] as int?,
        details: error?['details'],
      );
    }
    return ApiException(
      message: 'Unknown error occurred',
    );
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'Unauthorized access']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ValidationException(this.message, [this.errors]);

  @override
  String toString() => 'ValidationException: $message';
}

class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}
