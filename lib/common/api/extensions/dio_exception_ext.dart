import 'package:dio/dio.dart';

import '../api.dart';

extension DioExceptionToApiError on DioException {
  ApiError<T> toApiError<T>() {
    if (type == DioExceptionType.cancel) {
      if (error case ApiErrorType.unauthorized) {
        return ApiError(errorType: ApiErrorType.unauthorized);
      }

      return ApiError(errorType: ApiErrorType.cancelled);
    }

    if (type == DioExceptionType.connectionError) {
      return ApiError(errorType: ApiErrorType.connectionError);
    }

    if (response == null) {
      return ApiError(errorType: ApiErrorType.localError);
    }

    return response!.toApiError();
  }
}
