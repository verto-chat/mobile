import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';

extension RegisterErrToDialog on RegisterErrorResult {
  DialogInfo toDialog(BuildContext context) {
    switch (this) {
      case RegisterDefaultError(:final domainErrorType):
        return domainErrorType.toDialogInfo(context);
      case RegisterError(:final type):
        final errorMsg = _convertErrorTypeToMsg(context, type);

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

  String _convertErrorTypeToMsg(BuildContext context, RegisterErrorType type) {
    final registerError = context.appTexts.auth.sign_up_screen.register_error;

    return switch (type) {
      RegisterErrorType.other => context.appTexts.core.dialog_msg.retry_or_contact_support,
      RegisterErrorType.incorrectEmail => registerError.incorrect_email,
      RegisterErrorType.incorrectName => registerError.incorrect_name,
      RegisterErrorType.incorrectPassword => registerError.incorrect_password,
      RegisterErrorType.emailAlreadyUsed => registerError.email_already_used,
      RegisterErrorType.createError => registerError.create_error,
      RegisterErrorType.emailRateLimitExceeded => registerError.email_rate_limit_exceeded,
    };
  }
}
