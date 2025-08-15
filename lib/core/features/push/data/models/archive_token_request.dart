import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_token_request.g.dart';

@JsonSerializable()
class ArchiveTokenRequest {
  ArchiveTokenRequest({required this.token});

  final String token;

  Map<String, dynamic> toJson() => _$ArchiveTokenRequestToJson(this);
}
