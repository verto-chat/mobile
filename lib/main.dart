import 'package:flutter/material.dart';

import 'app.dart';
import 'startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialDependencies = await configure();

  runApp(VertoChatApp(initialDependencies: initialDependencies));
}
