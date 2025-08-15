import 'package:freezed_annotation/freezed_annotation.dart';

import 'location.dart';

part 'address.freezed.dart';

@freezed
sealed class Address with _$Address {
  const factory Address({required Location location, required Map<AddressComponentKind, String> addressComponents}) =
      _Address;
}

enum AddressComponentKind {
  unknown,
  country,
  region,
  province,
  area,
  locality,
  district,
  street,
  house,
  entrance,
  route,
  station,
  metroStation,
  railwayStation,
  vegetation,
  hydro,
  airport,
  other,
}
