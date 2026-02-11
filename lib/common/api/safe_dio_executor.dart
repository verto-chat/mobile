import 'dart:async';

import 'package:dio/dio.dart';

import '../common.dart';

class SafeDio {
  final ILogger _logger;

  SafeDio(this._logger);

  Future<ApiResult<T>> execute<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request.call();

      return ApiSuccess(data: response.data as T);
    } catch (e) {
      if (e is DioException) {
        //this will be logged by talker
        return e.toApiError();
      }

      _logger.log(LogLevel.error, 'local error on execute', exception: e);

      return ApiError(errorType: ApiErrorType.localError);
    }
  }

  Future<ApiResult<T>> executeReliably<T>(Future<Response<T>> Function() request) async {
    final response = await execute<T>(request);

    if (response is ApiSuccess<T>) {
      return response;
    }

    // if (response is ApiError<T>) {
    //   final errorType = response.errorType;
    //
    //   if (errorType == ApiErrorType.unauthorized) {
    //     if (_tokenProvider != null) {
    //       final token = await _tokenProvider!.getToken();
    //
    //       if (token != null) {
    //         final refreshResult = await _tokenProvider!.refreshToken(token);
    //
    //         switch (refreshResult) {
    //           case RefreshTokenResult.success:
    //             final retryResponse = await execute<T>(request);
    //
    //             if (retryResponse is ApiError<T> && retryResponse.errorType == ApiErrorType.unauthorized) {
    //               await _tokenProvider!.clearToken();
    //             }
    //
    //             return retryResponse;
    //           case RefreshTokenResult.failed:
    //             return response;
    //           case RefreshTokenResult.connectionErr:
    //             return ApiError<T>(errorType: ApiErrorType.connectionError);
    //         }
    //       }
    //     }
    //     _logger?.log(LogLevel.trace, 'token provider was\'t set');
    //   }
    // }

    return response;
  }
}
