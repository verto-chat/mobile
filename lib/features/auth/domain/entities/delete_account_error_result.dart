import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'delete_account_error_result.freezed.dart';

enum DeleteAccountErrorType { other, requiresRecentLogin }

@freezed
sealed class DeleteAccountErrorResult with _$DeleteAccountErrorResult {
  const factory DeleteAccountErrorResult.defaultError(DomainErrorType domainErrorType) = DeleteAccountDefaultError;

  const factory DeleteAccountErrorResult.registerError(List<DeleteAccountErrorType> registerErrTypes) =
      DeleteAccountError;
}
