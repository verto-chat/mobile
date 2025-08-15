import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common.dart';
import '../../../i18n/translations.g.dart';
import '../../../router/app_router.dart';
import '../../core.dart';

class DialogCorePresenter {
  static Future<T?> showMessage<T extends Enum>(BuildContext context, DialogInfo<T> info) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return DialogMessageContent<T>(info);
      },
    );
  }
}

class DialogPresenter {
  static Future<ErrorActionType?> showErrorMessage({
    required DomainErrorType errorData,
    required BuildContext context,
    String? customMessage,
  }) async {
    final router = context.router;
    final dialogInfo = errorData.toDialogInfo(context, customMessage: customMessage);

    final onErrorMsg = await DialogCorePresenter.showMessage(context, dialogInfo);

    if (onErrorMsg == ErrorActionType.login) {
      await router.navigate(const SignInRoute());

      return onErrorMsg;
    }

    if (onErrorMsg == ErrorActionType.upgrade && errorData is UpgradeRequired) {
      if (context.mounted) {
        context.read<ExternalOpenUrl>().call(errorData.storeUrl);
      }
    }

    return onErrorMsg;
  }

  static Future<bool> showPermissionDeniedDialog(BuildContext context, PermissionType permissionType) async {
    final loc = context.appTexts.core.dialog_presenter;

    final permissionText = switch (permissionType) {
      PermissionType.location => loc.permission_text_location,
      _ => throw UnimplementedError(),
    };

    final info = DialogInfo(
      title: loc.permission_denied.title(permission: permissionText),
      description: loc.permission_denied.description(permission: permissionText),
      actions: [
        DialogActionInfo(
          actionType: PermissionDeniedAction.settings,
          actionName: loc.permission_denied.settings,
          actionStyle: DialogActionStyle.primary,
        ),
        DialogActionInfo(
          actionType: PermissionDeniedAction.later,
          actionName: loc.permission_denied.later,
          actionStyle: DialogActionStyle.secondary,
        ),
      ],
    );

    final result = await DialogCorePresenter.showMessage(context, info);

    if (result != null && result == PermissionDeniedAction.settings) {
      return await PermissionService.openSettings();
    }

    return false;
  }
}

enum PermissionDeniedAction { later, settings }
