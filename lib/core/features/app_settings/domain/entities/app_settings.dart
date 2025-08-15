import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
sealed class AppSettings with _$AppSettings {
  const factory AppSettings({required bool hasInternalAccess}) = _AppSetting;
}
