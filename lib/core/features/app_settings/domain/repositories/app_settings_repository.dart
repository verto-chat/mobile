import 'dart:async';

import '../entities/entities.dart';

abstract interface class IAppSettingsRepository {
  FutureOr<AppSettings?> getSettings();
}