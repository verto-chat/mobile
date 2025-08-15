part of 'upload_file_bloc.dart';

@freezed
class UploadFileEvent with _$UploadFileEvent {
  const factory UploadFileEvent.started({
    required UploadPhotoFunction uploadFunction,
    required File file,
    required UploadedLocalFile localFile,
  }) = _Started;

  const factory UploadFileEvent.upload() = _Upload;
}
