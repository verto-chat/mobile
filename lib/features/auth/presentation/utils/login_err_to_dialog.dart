import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

extension LoginErrToDialog on LoginErrorResult {
  DialogInfo toDialog(BuildContext context) {
    switch (this) {
      case LoginDefaultError(:final domainErrorType):
        return domainErrorType.toDialogInfo(context);
      case LoginError(:final registerErrTypes):
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

  String _convertErrorTypeToMsg(BuildContext context, List<LoginErrorType> errorTypes) {
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

  String _errorTypeToMsg(BuildContext context, LoginErrorType errorType) {
    final loc = context.appTexts.auth.sign_in_screen.login_error;

    return switch (errorType) {
      LoginErrorType.other => context.appTexts.core.dialog_msg.retry_or_contact_support,
      LoginErrorType.emailNotConfirmed => loc.email_not_confirmed,
      LoginErrorType.invalidCredentials => loc.invalid_credentials,
    };
  }
}
