import '../domain/uploaded_file.dart';

class UploadFilesController {
  void Function(UploadedImageUrl file, int newIndex)? _onMoveFile;
  void Function(UploadedImageUrl file)? _onRemoveFile;

  final int maxFilesCount;

  UploadFilesController({this.maxFilesCount = 10});

  void bind({
    required void Function(UploadedImageUrl file, int newIndex) onMoveFile,
    required void Function(UploadedImageUrl file) onRemoveFile,
  }) {
    _onMoveFile = onMoveFile;
    _onRemoveFile = onRemoveFile;
  }

  void moveFile(UploadedImageUrl file, {required int index}) {
    _onMoveFile?.call(file, index);
  }

  void remove(UploadedImageUrl file) {
    _onRemoveFile?.call(file);
  }

  void dispose() {
    _onMoveFile = null;
    _onRemoveFile = null;
  }
}
