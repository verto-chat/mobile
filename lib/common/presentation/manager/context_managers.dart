import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yx_state/yx_state.dart';

abstract interface class IContextManager {
  BuildContext get context;
}

abstract class ContextBloc<E, S> extends Bloc<E, S> implements IContextManager {
  ContextBloc(super.initialState, this.context);

  @override
  final BuildContext context;
}

abstract class ContextCubit<S> extends Cubit<S> implements IContextManager {
  ContextCubit(super.initialState, this.context);

  @override
  final BuildContext context;
}

abstract class ContextStateManager<S> extends StateManager<S> implements IContextManager {
  ContextStateManager(super.state, this.context);

  @override
  final BuildContext context;
}
