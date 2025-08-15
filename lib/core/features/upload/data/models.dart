import 'package:json_annotation/json_annotation.dart';

import '../../../core.dart';

part 'models.g.dart';

@JsonSerializable()
class UploadedImageDto {
  final String imageUrl;
  final String thumbnailImageUrl;

  UploadedImageDto(this.imageUrl, this.thumbnailImageUrl);

  factory UploadedImageDto.fromJson(Map<String, dynamic> json) => _$UploadedImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedImageDtoToJson(this);

  UploadedImageUrl toEntity() {
    return UploadedImageUrl(imageUrl: imageUrl, thumbnailImageUrl: thumbnailImageUrl);
  }
}

@JsonSerializable()
class UploadedFileDto {
  final String fileUrl;

  UploadedFileDto(this.fileUrl);

  factory UploadedFileDto.fromJson(Map<String, dynamic> json) => _$UploadedFileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedFileDtoToJson(this);
}
