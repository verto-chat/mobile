part of 'code_bloc.dart';

@freezed
sealed class CodeState with _$CodeState {
  const factory CodeState({
    required String email,
    @Default(false) bool isLoading,
    @Default('') String code,
    @Default(ResetCodeStatus.undefined) ResetCodeStatus codeStatus,
  }) = _CodeState;
}
