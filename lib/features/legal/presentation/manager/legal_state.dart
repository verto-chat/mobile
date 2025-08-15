part of 'legal_bloc.dart';

@freezed
sealed class LegalState with _$LegalState {
  const factory LegalState({@Default(false) bool isLoaded}) = _LegalState;
}
