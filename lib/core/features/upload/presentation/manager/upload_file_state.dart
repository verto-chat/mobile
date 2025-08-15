part of 'upload_file_bloc.dart';

@freezed
class UploadFileState with _$UploadFileState {
  const factory UploadFileState.initial() = UploadFileInitial;

  const factory UploadFileState.loading() = UploadFileLoading;

  const factory UploadFileState.failure() = UploadFileFailure;

  const factory UploadFileState.uploaded({
    required UploadedLocalFile loadFile,
    required UploadedImageUrl uploadedFile,
  }) = UploadFileUploaded;
}
