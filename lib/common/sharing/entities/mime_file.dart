import 'mime_type.dart';

class MimeFile {
  MimeFile({required this.filePath, required this.fileName, required this.mimeType});

  final String filePath;
  final String fileName;
  final MimeType mimeType;
}
