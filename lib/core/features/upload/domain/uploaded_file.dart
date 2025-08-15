import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_file.freezed.dart';

enum FileType { image, document }

@freezed
sealed class UploadedFile with _$UploadedFile {
  const factory UploadedFile.local({required String filePath, required FileType fileType}) = UploadedLocalFile;

  const factory UploadedFile.fileUrl({required String fileUrl}) = UploadedFileUrl;

  const factory UploadedFile.imageUrl({required String imageUrl, required String thumbnailImageUrl}) = UploadedImageUrl;
}
