import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';

part 'feedback_bloc.freezed.dart';
part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends ContextBloc<FeedbackEvent, FeedbackState> {
  final IFeedbackRepository _repository;

  FeedbackBloc(BuildContext context, FeedbackType type, this._repository)
    : super(FeedbackState(type: type, description: ''), context) {
    on<_ChangeType>(_onChangeType);
    on<_ChangeDescription>(_onChangeDescription);
    on<_SendFeedback>(_onSendFeedback);
  }

  void _onChangeType(_ChangeType event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(type: event.type));
  }

  void _onChangeDescription(_ChangeDescription event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(description: event.description.trim()));
  }

  Future<void> _onSendFeedback(_SendFeedback event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _repository.sendFeedback(state.type, state.description.trim());

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        showToast(message: appTexts.feedback.feedback_page.success);
        router?.maybePop();
      case Error():
        showError(result.errorData, customMessage: appTexts.feedback.feedback_page.failed_send_feedback);
    }
  }
}
