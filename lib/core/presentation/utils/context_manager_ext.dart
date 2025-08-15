import 'dart:async';

import 'package:auto_route/auto_route.dart';

import '../../../common/common.dart';
import '../../../i18n/translations.g.dart';
import '../../core.dart';

extension DialogCoreExtension on IContextManager {
  Future<T?> showMessage<T extends Enum>(DialogInfo<T> dialogInfo) async {
    if (!context.mounted) return null;

    return await DialogCorePresenter.showMessage(context, dialogInfo);
  }

  Future<bool> showActionMessage(
    String title,
    String description,
    String actionName, {
    DialogActionStyle actionStyle = DialogActionStyle.primary,
  }) async {
    if (!context.mounted) return false;

    final result = await DialogCorePresenter.showMessage(
      context,
      DialogInfo(
        title: title,
        description: description,
        actions: [DialogActionInfo(actionType: ErrorActionType.ok, actionName: actionName, actionStyle: actionStyle)],
      ),
    );

    return result == ErrorActionType.ok;
  }
}

extension DialogExtension on IContextManager {
  FutureOr<ErrorActionType?> showError(DomainErrorType errorData, {String? customMessage}) {
    if (!context.mounted) return null;

    return DialogPresenter.showErrorMessage(customMessage: customMessage, errorData: errorData, context: context);
  }
}

extension ToastCoreExtension on IContextManager {
  void showToast({required String message, Duration duration = const Duration(seconds: 1)}) {
    if (!context.mounted) return;

    ToastPresenter.showToast(context: context, message: message, duration: duration);
  }
}

extension RouterExtension on IContextManager {
  StackRouter? get router => context.mounted ? context.router : null;
}

extension AppTextsExtension on IContextManager {
  Translations get appTexts => context.appTexts;
}
