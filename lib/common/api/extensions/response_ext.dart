import 'package:dio/dio.dart';

import '../api.dart';

extension ResponseToApiError on Response<dynamic> {
  ApiError<T> toApiError<T>() {
    if (statusCode == 403) {
      return ApiError(errorType: ApiErrorType.insufficientAccessRights, data: data);
    }

    if (statusCode == 400 || statusCode == 415 || statusCode == 404) {
      return ApiError(errorType: ApiErrorType.rejected, data: data);
    }

    if (statusCode == 401) {
      return ApiError(errorType: ApiErrorType.unauthorized, data: data);
    }

    if (statusCode == 409 || statusCode == 406) {
      return ApiError(errorType: ApiErrorType.attentionRequired, data: data);
    }

    if (statusCode == 426) {
      return ApiError(errorType: ApiErrorType.upgradeRequired, data: data);
    }

    return ApiError(errorType: ApiErrorType.serverError, data: data);
  }
}
