import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../../i18n/translations.g.dart';
import 'dialog_action_info.dart';
import 'dialog_info.dart';

enum ErrorActionType { ok, login, upgrade, cancel }

extension DomainErrorToDialog on DomainErrorType {
  DialogInfo<ErrorActionType> toDialogInfo(BuildContext context, {String? customMessage}) {
    switch (this) {
      case InsufficientAccessRights():
        return DialogInfo<ErrorActionType>(
          title: context.appTexts.core.dialog_title.insufficient_access_rights,
          subtitle: customMessage,
          description: context.appTexts.core.dialog_msg.insufficient_access_rights,
          actions: [_getDefaultErrorAction(context)],
        );

      case Unauthorized():
        return DialogInfo<ErrorActionType>(
          title: context.appTexts.core.dialog_title.not_authorized,
          subtitle: customMessage,
          description: context.appTexts.core.dialog_msg.authorization_required,
          actions: _getUnauthorizedActions(context),
        );

      case ConnectionError():
        return DialogInfo<ErrorActionType>(
          title: context.appTexts.core.dialog_title.connection_error,
          subtitle: customMessage,
          description: context.appTexts.core.dialog_msg.connection_error,
          actions: [_getDefaultErrorAction(context)],
        );

      case ServerError():
        return DialogInfo<ErrorActionType>(
          title: context.appTexts.core.dialog_title.server_error,
          subtitle: customMessage,
          description: context.appTexts.core.dialog_msg.server_error(
            retryOrContactSupport: context.appTexts.core.dialog_msg.retry_or_contact_support,
          ),
          actions: [_getDefaultErrorAction(context)],
        );

      case UpgradeRequired():
        return DialogInfo<ErrorActionType>(
          title: context.appTexts.core.dialog_title.upgrade_required,
          subtitle: customMessage,
          description: context.appTexts.core.dialog_msg.upgrade_required,
          actions: [_getUpgradeAction(context)],
        );

      case ErrorDefaultType():
        return DialogInfo<ErrorActionType>(
          title: context.appTexts.core.dialog_title.error_title,
          subtitle: customMessage,
          description: context.appTexts.core.dialog_msg.default_error(
            retryOrContactSupport: context.appTexts.core.dialog_msg.retry_or_contact_support,
          ),
          actions: [_getDefaultErrorAction(context)],
        );

      case AdditionalErrorDescription(:final title):
        return DialogInfo<ErrorActionType>(
          title: title ?? context.appTexts.core.dialog_title.error_title,
          description: (this as AdditionalErrorDescription).description,
          actions: [_getDefaultErrorAction(context)],
        );
    }
  }

  DialogActionInfo<ErrorActionType> _getDefaultErrorAction(BuildContext context) {
    return DialogActionInfo<ErrorActionType>(
      actionType: ErrorActionType.ok,
      actionName: context.appTexts.core.dialog_action.ok,
      actionStyle: DialogActionStyle.primary,
    );
  }

  List<DialogActionInfo<ErrorActionType>> _getUnauthorizedActions(BuildContext context) {
    return [
      DialogActionInfo<ErrorActionType>(
        actionType: ErrorActionType.login,
        actionName: context.appTexts.core.dialog_action.login,
        actionStyle: DialogActionStyle.primary,
      ),
      DialogActionInfo<ErrorActionType>(
        actionType: ErrorActionType.ok,
        actionName: context.appTexts.core.dialog_action.ok,
        actionStyle: DialogActionStyle.secondary,
      ),
    ];
  }

  DialogActionInfo<ErrorActionType> _getUpgradeAction(BuildContext context) {
    return DialogActionInfo<ErrorActionType>(
      actionType: ErrorActionType.upgrade,
      actionName: context.appTexts.core.dialog_action.upgrade,
      actionStyle: DialogActionStyle.primary,
    );
  }
}
