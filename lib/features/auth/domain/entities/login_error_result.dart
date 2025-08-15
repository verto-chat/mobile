import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'login_error_result.freezed.dart';

enum LoginErrorType {
  other,
  invalidCredentials,
  emailNotConfirmed, //Не подтверждена эл. почта
}

@freezed
sealed class LoginErrorResult with _$LoginErrorResult {
  const factory LoginErrorResult.defaultError(DomainErrorType domainErrorType) = LoginDefaultError;

  const factory LoginErrorResult.registerError(List<LoginErrorType> registerErrTypes) = LoginError;
}
