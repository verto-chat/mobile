import 'metrica_interface.dart';

class FakeMetrica implements IMetrica {
  @override
  void event(String message, {Map<String, dynamic>? params}) {
    // nothing here...
  }
}
