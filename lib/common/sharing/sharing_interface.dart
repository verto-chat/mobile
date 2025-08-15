import 'dart:io';

import 'package:async/async.dart';

import 'entities/mime_file.dart';

abstract interface class IShare {
  Future<bool> shareMimeFile(MimeFile input);

  Future<bool> shareFile(File file);

  CancelableOperation<bool> shareText(String text, {String? imageUrl});
}
