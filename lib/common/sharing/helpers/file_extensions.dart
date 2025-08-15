import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../entities/entities.dart';

extension FileExtensions on File {
  MimeFile toMimeFile() {
    final String fileName = path.split('/').last;
    final List<String> fileParts = fileName.split('.');

    if (fileParts.isEmpty) {
      return MimeFile(
        filePath: path,
        fileName: fileName,
        mimeType: MimeType.undefined,
      );
    }

    final String fileExtension = fileParts.last;

    MimeType mimeType;
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        mimeType = MimeType.image;
        break;
      case 'txt':
      case 'log':
      mimeType = MimeType.text;
        break;
      case 'zip':
        mimeType = MimeType.archive;
        break;
      default:
        throw UnsupportedError('Unsupported file format');
    }

    return MimeFile(
      filePath: path,
      fileName: fileName,
      mimeType: mimeType,
    );
  }
}

extension MimeFileExtensions on MimeFile {
  XFile toXFile() {
    String mime;
    switch (mimeType) {
      case MimeType.image:
        mime = 'image/*';
        break;
      case MimeType.text:
        mime = 'text/plain';
        break;
      case MimeType.archive:
        mime = 'application/zip';
        break;
      default:
        throw UnsupportedError('Unsupported MIME-type');
    }
    return XFile(
      filePath,
      mimeType: mime,
      name: fileName,
    );
  }
}
