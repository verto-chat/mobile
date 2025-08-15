import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'change_password_status.freezed.dart';

enum ChangePasswordStatus { incorrect, wrongCurrentPassword, samePassword }

@freezed
sealed class ChangePasswordErrorResult with _$ChangePasswordErrorResult {
  const factory ChangePasswordErrorResult.defaultError(DomainErrorType domainErrorType) = ChangePasswordDefaultError;

  const factory ChangePasswordErrorResult.changePassword(ChangePasswordStatus type) = ChangePasswordError;
}
