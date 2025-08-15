import '../../common.dart';

extension ApiErrorExtension<T> on ApiError<T> {
  DomainErrorType toDomain() {
    switch (errorType) {
      case ApiErrorType.insufficientAccessRights:
        return _checkForAdditionalError(const DomainErrorType.insufficientAccessRights());
      case ApiErrorType.unauthorized:
        return const DomainErrorType.unauthorized();

      case ApiErrorType.connectionError:
        return const DomainErrorType.connectionError();

      case ApiErrorType.serverError:
        return const DomainErrorType.serverError();

      case ApiErrorType.upgradeRequired:
        final dataMap = getAdditionalDataSafe<Map<String, dynamic>>();
        final storeUrl = dataMap != null && dataMap.containsKey("storeUrl") ? dataMap["storeUrl"] : null;

        if (storeUrl is String) {
          return DomainErrorType.upgradeRequired(storeUrl: storeUrl);
        }

        return const DomainErrorType.serverError();

      case ApiErrorType.attentionRequired:
      case ApiErrorType.rejected:
        return _checkForAdditionalError(const DomainErrorType.errorDefaultType());

      case ApiErrorType.localError:
      case ApiErrorType.cancelled:
        return const DomainErrorType.errorDefaultType();
    }
  }

  DomainErrorType _checkForAdditionalError(DomainErrorType initialType) {
    final dataMap = getAdditionalDataSafe<Map<String, dynamic>>();

    final additionalCode = dataMap != null && dataMap.containsKey("errorCode") ? dataMap["errorCode"] : null;
    final description = dataMap != null && dataMap.containsKey("errorMessage") ? dataMap["errorMessage"] : null;
    final title = dataMap != null && dataMap.containsKey("errorTitle") ? dataMap["errorTitle"] : null;

    if (additionalCode is! int || description is! String) {
      return initialType;
    }

    return DomainErrorType.additionalErrorDescription(description: description, title: title is String ? title : null);
  }
}
