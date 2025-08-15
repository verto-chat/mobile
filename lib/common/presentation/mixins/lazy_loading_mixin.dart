import 'package:flutter_bloc/flutter_bloc.dart';

mixin LazyLoadingMixin<T extends Object?> on BlocBase<T> {
  bool _isVisible = false;
  bool _needToUpdate = false;

  void visibleChanged({required bool isVisible}) {
    _isVisible = isVisible;

    if (isVisible && _needToUpdate) {
      _needToUpdate = false;
      onRefresh();
    }
  }

  void lazyRefresh({void Function()? invisibleAction}) {
    if (!_isVisible) {
      _needToUpdate = true;
      invisibleAction?.call();
    } else {
      onRefresh();
    }
  }

  void onRefresh() {}
}
