import 'dart:async';

import '../../entities/entities.dart';

abstract interface class IShareLogFileService {
  Future<void> initService();

  Future<ShareActionStatus> share(SessionInfo data);
}

enum ShareActionStatus { success, noSpaceLeft, unknown }
