import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'reset_password_result.freezed.dart';

enum ResetPasswordStatus { incorrect, samePassword }

@freezed
sealed class ResetPasswordErrorResult with _$ResetPasswordErrorResult {
  const factory ResetPasswordErrorResult.defaultError(DomainErrorType domainErrorType) = ResetPasswordDefaultError;

  const factory ResetPasswordErrorResult.changePassword(ResetPasswordStatus type) = ResetPasswordError;
}
