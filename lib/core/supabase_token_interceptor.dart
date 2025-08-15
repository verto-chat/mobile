import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core.dart';

class SupabaseTokenInterceptor extends Interceptor {
  final SupabaseClient _supabase;

  SupabaseTokenInterceptor(this._supabase);

  @override
  Future<dynamic> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Accept-Language'] = languageCodeNew;

    final token = _supabase.auth.currentSession?.accessToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      return super.onRequest(options, handler);
    }

    return super.onRequest(options, handler);
    //return handler.reject(DioException.requestCancelled(requestOptions: options, reason: ApiErrorType.unauthorized));
  }
}
