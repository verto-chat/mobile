part of 'upload_files_bloc.dart';

@freezed
sealed class UploadFilesState with _$UploadFilesState {
  const factory UploadFilesState({required List<UploadedFile> files}) = _UploadFilesState;
}
