import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../router/app_router.dart';
import '../../auth.dart';

part 'code_bloc.freezed.dart';
part 'code_event.dart';
part 'code_state.dart';

class CodeBloc extends ContextBloc<CodeEvent, CodeState> {
  final IAuthRepository _authRepository;

  CodeBloc(BuildContext context, String email, this._authRepository) : super(CodeState(email: email), context) {
    on<_CodeChanged>(_onCodeChanged);
    on<_Submit>(_onSubmit);
  }

  void _onCodeChanged(_CodeChanged event, Emitter<CodeState> emit) {
    emit(state.copyWith(code: event.value, codeStatus: ResetCodeStatus.undefined));
  }

  Future<void> _onSubmit(_Submit event, Emitter<CodeState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _authRepository.checkResetCode(email: state.email, code: state.code);

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success<ResetCodeStatus, DomainErrorType>():
        if (result.data == ResetCodeStatus.correct && context.mounted) {
          router?.replace(NewPasswordRoute(navigationPurpose: NewPasswordNavigationPurpose.reset));
          return;
        }

        emit(state.copyWith(codeStatus: ResetCodeStatus.incorrect));
      case Error<ResetCodeStatus, DomainErrorType>():
        showError(result.errorData, customMessage: appTexts.auth.reset_password.code_screen.check_error_description);
    }
  }
}
