import 'package:flutter_bloc/flutter_bloc.dart';

extension SafelyExtension<E, S> on Bloc<E, S> {
  /// Add event to bloc safely
  void addSafely(E event) {
    if (isClosed) return;
    add(event);
  }
}
