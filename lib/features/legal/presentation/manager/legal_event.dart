part of 'legal_bloc.dart';

@freezed
class LegalEvent with _$LegalEvent {
  const factory LegalEvent.openPolicy() = _OpenPolicy;

  const factory LegalEvent.openTerms() = _OpenTerms;

  const factory LegalEvent.openGdpr() = _OpenGdpr;
}
