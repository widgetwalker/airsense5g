import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:air_quality_guardian/core/constants/api_constants.dart';
import 'package:air_quality_guardian/core/constants/app_constants.dart';
import 'package:air_quality_guardian/core/exceptions/api_exception.dart';

class ApiInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token to headers if available
    final token = await _secureStorage.read(key: AppConstants.keyAuthToken);
    if (token != null) {
      options.headers[ApiConstants.headerAuthorization] =
          ApiConstants.bearerToken(token);
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Check if response has success field
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('success') && data['success'] == false) {
        // API returned error in success response
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle different error types
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Retry the request
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // Refresh failed, clear tokens and throw unauthorized
          await _clearTokens();
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: UnauthorizedException(),
              type: DioExceptionType.badResponse,
            ),
          );
          return;
        }
      } else {
        await _clearTokens();
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(),
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
    }

    // Transform DioException to custom exceptions
    Exception exception;
    
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      exception = NetworkException('Connection timeout');
    } else if (err.type == DioExceptionType.connectionError) {
      exception = NetworkException('No internet connection');
    } else if (err.response != null) {
      final statusCode = err.response!.statusCode;
      
      if (statusCode == 404) {
        exception = NotFoundException();
      } else if (statusCode == 400) {
        exception = ValidationException(
          err.response!.data?['error']?['message'] ?? 'Validation error',
          err.response!.data?['error']?['details'],
        );
      } else if (statusCode! >= 500) {
        exception = ServerException();
      } else {
        exception = ApiException.fromResponse(err.response!.data);
      }
    } else {
      exception = NetworkException('Network error occurred');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.keyRefreshToken,
      );
      
      if (refreshToken == null) return false;

      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await dio.post(
        ApiConstants.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['data']['token'] as String;
        final newRefreshToken = response.data['data']['refreshToken'] as String;

        await _secureStorage.write(
          key: AppConstants.keyAuthToken,
          value: newToken,
        );
        await _secureStorage.write(
          key: AppConstants.keyRefreshToken,
          value: newRefreshToken,
        );

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: AppConstants.keyAuthToken);
    await _secureStorage.delete(key: AppConstants.keyRefreshToken);
    await _secureStorage.delete(key: AppConstants.keyUserId);
  }
}
