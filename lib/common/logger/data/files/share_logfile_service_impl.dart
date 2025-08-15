import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common.dart';
import '../../domain/logger_repository.dart';
import 'share_logfile_service_interface.dart';

class ShareLogFileService implements IShareLogFileService {
  static Future<bool>? _initFuture;
  static late final Future<void> _cleanFuture;
  final ILogger _logger;
  final IShare _share;
  final ILoggerRepository _loggerRepository;
  String? _path;

  ShareLogFileService(this._logger, this._share, this._loggerRepository);

  @override
  Future<void> initService() async {
    if (_initFuture != null) return;

    _initFuture = getTemporaryDirectory()
        .then((directory) => _path = "${directory.path}/log")
        .then((_) async {
          var directory = Directory(_path!);

          if (!await directory.exists()) {
            await directory.create();
          }
        })
        .then((_) => true)
        .onError((error, stackTrace) {
          _logger.log(LogLevel.warning, "FileService didn't available", exception: error, stacktrace: stackTrace);
          return false;
        });

    _cleanFuture = _initFuture!.whenComplete(() => _removeOldFiles());
  }

  @override
  Future<ShareActionStatus> share(SessionInfo data) async {
    if (!await _ensureInitialized()) {
      return ShareActionStatus.unknown;
    }

    await _cleanFuture;

    List<Log>? logs = await _loggerRepository.getLogByBoxId(data.key);

    final buffer = StringBuffer();
    if (logs == null || logs.isEmpty) return ShareActionStatus.unknown;

    buffer.writeAll(logs, '\n');

    var fileName = "${const Uuid().v4()}_${data.date}.log";
    ShareActionStatus response = await _write(fileName, buffer.toString());

    if (response == ShareActionStatus.success) {
      File file = File("$_path/$fileName");
      await _share.shareFile(file).then((_) => _delete(fileName));
    }

    return response;
  }

  Future<void> _delete(String fileName) async {
    var file = File("$_path/$fileName");

    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e, s) {
      _logger.log(
        LogLevel.warning,
        "Error deleting File - Path: ${file.path}, Mime: ${file.toMimeFile().mimeType}",
        exception: e,
        stacktrace: s,
      );
    }
  }

  Future<ShareActionStatus> _write(String fileName, String value) async {
    var file = File("$_path/$fileName");

    if (!await file.exists()) {
      await file.create();
    }

    try {
      await file.writeAsString(value);
      return ShareActionStatus.success;
    } on FileSystemException catch (e, s) {
      if (e.osError?.errorCode == 28) {
        _logger.log(LogLevel.warning, "No left space in device", exception: e, stacktrace: s);
        return ShareActionStatus.noSpaceLeft;
      }
      _logger.log(LogLevel.warning, "Couldn't write in file", exception: e, stacktrace: s);
      return ShareActionStatus.unknown;
    } catch (e, s) {
      _logger.log(LogLevel.warning, "Couldn't write in file", exception: e, stacktrace: s);
      return ShareActionStatus.unknown;
    }
  }

  Future<bool> _ensureInitialized() {
    if (_initFuture == null) {
      return Future.value(false);
    }

    return _initFuture!;
  }

  void _removeOldFiles() async {
    if (_path == null) return;

    await for (FileSystemEntity entity in Directory(_path!).list()) {
      if (entity is File) {
        entity.delete().onError((error, stackTrace) {
          _logger.log(LogLevel.warning, "Couldn't delete file", exception: error, stacktrace: stackTrace);
          return File("");
        });
      }
    }
  }
}
