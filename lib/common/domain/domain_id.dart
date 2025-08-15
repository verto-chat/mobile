import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_id.freezed.dart';

@freezed
sealed class DomainId with _$DomainId {
  const factory DomainId.fromString({required String id}) = _StringId;

  const factory DomainId.fromInt({required int id}) = _IntId;

  const DomainId._();

  @override
  String toString() => switch (this) {
    _StringId(:final id) => id,
    _IntId(:final id) => id.toString(),
  };

  int toInt({int defaultValue = 0}) => switch (this) {
    _StringId(:final id) => int.tryParse(id) ?? defaultValue,
    _IntId(:final id) => id,
  };

  int? tryGetInt() => switch (this) {
    _StringId(:final id) => int.tryParse(id),
    _IntId(:final id) => id,
  };

  @override
  int get hashCode => switch (this) {
    _StringId(:final id) => id.hashCode,
    _IntId(:final id) => id.hashCode,
  };

  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }
}
