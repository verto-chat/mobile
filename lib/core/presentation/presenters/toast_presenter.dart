import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/widgets.dart';

class ToastPresenter {
  static final _fToast = FToast();

  static void showToast({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 1),
  }) {
    if (_fToast.context != context) {
      _fToast.init(context);
    }

    _fToast.showToast(
      child: CustomToast(message: message),
      gravity: ToastGravity.TOP,
      toastDuration: duration,
    );
  }
}
