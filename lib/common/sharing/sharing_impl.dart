import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../common.dart';

class ShareImpl implements IShare {
  final ILogger _logger;

  ShareImpl(this._logger);

  @override
  Future<bool> shareMimeFile(MimeFile mimeFile) async {
    final File file = File(mimeFile.filePath);
    bool pathExists = await file.exists().onError((e, s) {
      _logger.log(LogLevel.warning, "Sharing file didn't available", exception: e, stacktrace: s);
      return false;
    });

    if (!pathExists) {
      return false;
    }

    return await _shareFile(mimeFile);
  }

  @override
  Future<bool> shareFile(File file) {
    return shareMimeFile(file.toMimeFile());
  }

  @override
  CancelableOperation<bool> shareText(String text, {String? imageUrl}) {
    final cancelToken = CancelToken();

    final future = Future<bool>(() async {
      try {
        if (imageUrl == null) {
          await SharePlus.instance.share(ShareParams(text: text));
          return true;
        }

        final tempDir = await getTemporaryDirectory();
        final savePath = '${tempDir.path}/shared_image.jpg';

        await Dio().download(
          imageUrl,
          savePath,
          options: Options(responseType: ResponseType.bytes),
          cancelToken: cancelToken,
        );

        if (cancelToken.isCancelled) return false;

        await SharePlus.instance.share(ShareParams(files: [XFile(savePath)], text: text, subject: text));
        return true;
      } catch (e, s) {
        _logger.log(LogLevel.error, "Error sharing image with text", exception: e, stacktrace: s);

        return false;
      }
    });

    return CancelableOperation.fromFuture(future, onCancel: () => cancelToken.cancel());
  }

  Future<bool> _shareFile(MimeFile mimeFile) async {
    try {
      final ShareResult result = await SharePlus.instance.share(ShareParams(files: [mimeFile.toXFile()]));

      return Future.value(result.status == ShareResultStatus.success);
    } catch (e, s) {
      _logger.log(LogLevel.error, "Error sending file", exception: e, stacktrace: s);

      return Future.value(false);
    }
  }
}
