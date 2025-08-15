import 'api_error_type.dart';

sealed class ApiResult<T> {}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;

  ApiSuccess({required this.data});
}

final class ApiError<T> extends ApiResult<T> {
  final ApiErrorType errorType;
  final dynamic _data;

  U getAdditionalDataAs<U>({U Function(dynamic data)? converter}) {
    if (converter != null) {
      return converter.call(_data);
    }

    return _data as U;
  }

  U? getAdditionalDataSafe<U>() {
    if (_data is U) {
      return _data;
    }

    return null;
  }

  ApiError({required this.errorType, dynamic data}) : _data = data;
}