import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import '../common.dart';

class AppMetricaMetrica implements IMetrica {
  @override
  void event(String eventName, {Map<String, Object>? params}) {
    AppMetrica.reportEventWithMap(eventName, params);
  }
}
