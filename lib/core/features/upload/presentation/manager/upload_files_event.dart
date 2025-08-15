part of 'upload_files_bloc.dart';

@freezed
class UploadFilesEvent with _$UploadFilesEvent {
  const factory UploadFilesEvent.selectFile() = _SelectFile;

  const factory UploadFilesEvent.uploaded(UploadedLocalFile loadFile, UploadedImageUrl uploadedFile, int index) =
      _Uploaded;

  const factory UploadFilesEvent.remove(UploadedFile file) = _Remove;

  const factory UploadFilesEvent.moveFile(UploadedFile file, int index) = _MoveFile;
}
