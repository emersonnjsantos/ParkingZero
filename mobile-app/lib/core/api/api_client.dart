import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;
  
  // URL base para o Backend no Cloud Run (exemplo)
  static const String baseUrl = 'https://backend-api-xyz-uc.a.run.app/api/v1';

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para logs e autenticação (JWT Firebase)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // TODO: Pegar token do Firebase Auth e injetar no header
          // options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Tratar erros globais (401, 500, etc)
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
