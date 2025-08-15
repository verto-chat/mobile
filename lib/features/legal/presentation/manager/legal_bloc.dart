import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/repositories/legal_repository.dart';

part 'legal_bloc.freezed.dart';
part 'legal_event.dart';
part 'legal_state.dart';

enum _LegalType { policy, terms, gdpr }

class LegalBloc extends ContextBloc<LegalEvent, LegalState> {
  final ExternalOpenUrl _openUrl;
  final ILegalRepository _legalRepository;

  LegalBloc(BuildContext context, this._openUrl, this._legalRepository) : super(const LegalState(), context) {
    on<_OpenPolicy>(_onOpenPolicy);
    on<_OpenTerms>(_onOpenTerms);
    on<_OpenGdpr>(_onOpenGdpr);
  }

  Future<void> _onOpenPolicy(LegalEvent event, Emitter<LegalState> emit) => _openLegal(_LegalType.policy, emit);

  Future<void> _onOpenTerms(LegalEvent event, Emitter<LegalState> emit) => _openLegal(_LegalType.terms, emit);

  Future<void> _onOpenGdpr(LegalEvent event, Emitter<LegalState> emit) => _openLegal(_LegalType.gdpr, emit);

  Future<void> _openLegal(_LegalType type, Emitter<LegalState> emit) async {
    emit(state.copyWith(isLoaded: true));

    final result = await _legalRepository.getInfo(languageCode: languageCode);

    emit(state.copyWith(isLoaded: false));

    switch (result) {
      case Success():
        await _openUrl(switch (type) {
          _LegalType.policy => result.data.policyUrl,
          _LegalType.terms => result.data.termsUrl,
          _LegalType.gdpr => result.data.gdprUrl,
        });
      case Error():
        showError(result.errorData, customMessage: appTexts.legal.failed_get_regulations);
    }
  }
}
