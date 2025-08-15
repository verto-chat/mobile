import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
sealed class Location with _$Location {
  const factory Location({required double lat, required double long}) = _Location;

  const Location._();
}
