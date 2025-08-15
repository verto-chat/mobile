part of 'code_bloc.dart';

@freezed
sealed class CodeEvent with _$CodeEvent {
  const factory CodeEvent.codeChanged(String value) = _CodeChanged;

  const factory CodeEvent.submit() = _Submit;
}
