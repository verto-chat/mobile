import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_error_type.freezed.dart';

@freezed
sealed class DomainErrorType with _$DomainErrorType {
  const factory DomainErrorType.insufficientAccessRights() = InsufficientAccessRights;

  const factory DomainErrorType.additionalErrorDescription({
    required String description,
    String? title,
  }) = AdditionalErrorDescription;

  const factory DomainErrorType.unauthorized() = Unauthorized;

  const factory DomainErrorType.connectionError() = ConnectionError;

  const factory DomainErrorType.serverError() = ServerError;

  const factory DomainErrorType.upgradeRequired({required String storeUrl}) = UpgradeRequired;

  const factory DomainErrorType.errorDefaultType() = ErrorDefaultType;
}
