import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../error/app_exception.dart';
import '../error/result.dart';

class DioClient {
  DioClient({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 45),
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: connectTimeout,
                receiveTimeout: receiveTimeout,
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.debug(
            'HTTP ${options.method} ${options.uri}',
            tag: 'DioClient',
          );
          handler.next(options);
        },
        onError: (error, handler) {
          AppLogger.error(
            'HTTP Error ${error.response?.statusCode}: ${error.message}',
            tag: 'DioClient',
            error: error,
          );
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;

  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<Result<Map<String, dynamic>>> postJson(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: body,
        options: Options(headers: headers),
      );
      return Success(response.data ?? const <String, dynamic>{});
    } on DioException catch (e) {
      return Failure(
        NetworkException(
          e.message ?? 'Network request failed',
          statusCode: e.response?.statusCode,
          cause: e,
        ),
      );
    } catch (e) {
      return Failure(NetworkException(e.toString(), cause: e));
    }
  }
}
