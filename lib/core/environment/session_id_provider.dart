import 'package:uuid/uuid.dart';

class SessionIdProvider {
  SessionIdProvider.create() : _sessionId = const Uuid().v4();

  final String _sessionId;

  String get sessionId => _sessionId;
}
