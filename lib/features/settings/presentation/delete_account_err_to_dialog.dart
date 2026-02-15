import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../i18n/translations.g.dart';
import '../../auth/auth.dart';

extension DeleteAccountErrToDialog on DeleteAccountErrorResult {
  DialogInfo toDialog(BuildContext context) {
    switch (this) {
      case DeleteAccountDefaultError(:final domainErrorType):
        return domainErrorType.toDialogInfo(context);
      case DeleteAccountError(:final registerErrTypes):
        final errorMsg = _convertErrorTypeToMsg(context, registerErrTypes);

        return DialogInfo(
          title: context.appTexts.core.dialog_title.error_title,
          description: errorMsg,
          actions: [
            DialogActionInfo<ErrorActionType>(
              actionType: ErrorActionType.ok,
              actionName: context.appTexts.core.dialog_action.ok,
              actionStyle: DialogActionStyle.primary,
            ),
          ],
        );
    }
  }

  String _convertErrorTypeToMsg(BuildContext context, List<DeleteAccountErrorType> errorTypes) {
    final buffer = StringBuffer();

    for (int i = 0; i < errorTypes.length; i++) {
      if (i == errorTypes.length - 1) {
        buffer.write(_errorTypeToMsg(context, errorTypes[i]));
        continue;
      }

      buffer.writeln(_errorTypeToMsg(context, errorTypes[i]));
    }

    return buffer.toString();
  }

  String _errorTypeToMsg(BuildContext context, DeleteAccountErrorType errorType) {
    final loc = context.appTexts.profile.safety_screen.delete_account_error;

    return switch (errorType) {
      DeleteAccountErrorType.other => context.appTexts.core.dialog_msg.retry_or_contact_support,
      DeleteAccountErrorType.requiresRecentLogin => loc.requires_recent_login,
    };
  }
}
