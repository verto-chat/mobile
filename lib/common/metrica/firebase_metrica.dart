import 'package:firebase_analytics/firebase_analytics.dart';

import 'metrica_interface.dart';

class FirebaseMetrica implements IMetrica {
  @override
  void event(String message, {Map<String, Object>? params}) {
    FirebaseAnalytics.instance.logEvent(name: message, parameters: params);
  }
}
