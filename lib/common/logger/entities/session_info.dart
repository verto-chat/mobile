import 'package:freezed_annotation/freezed_annotation.dart';

import 'log_level.dart';

part 'session_info.freezed.dart';

part 'session_info.g.dart';

@unfreezed
sealed class SessionInfo with _$SessionInfo {
  factory SessionInfo({required final String key, required final DateTime date, LogLevel? level}) = _SessionInfo;

  factory SessionInfo.fromJson(Map<String, Object?> json) => _$SessionInfoFromJson(json);
}
