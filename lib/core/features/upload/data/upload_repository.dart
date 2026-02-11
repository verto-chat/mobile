import 'dart:io';
import 'dart:typed_data';

import '../../../../common/common.dart';
import '../../../core.dart';
import 'supabase_upload_api.dart';

class UploadRepository implements IUploadRepository {
  final SupabaseUploadApi _supabaseUploadApi;
  final ILogger _logger;

  UploadRepository(this._supabaseUploadApi, this._logger);

  @override
  Future<DomainResultDErr<UploadedImageUrl>> uploadAvatar(File file) async {
    try {
      final compressedFile = await _compressImage(file);

      if (compressedFile == null) {
        return Error(errorData: const DomainErrorType.errorDefaultType());
      }

      final response = await _supabaseUploadApi.uploadAvatar(compressedFile.file, compressedFile.thumbBytes);

      await _safeDeleteFile(file);

      return Success(
        data: UploadedImageUrl(imageUrl: response.imageUrl, thumbnailImageUrl: response.thumbnailImageUrl),
      );
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to upload avatar", exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }

  @override
  Future<DomainResultDErr<UploadedImageUrl>> uploadAdvertPhoto(File file) async {
    try {
      final compressedFile = await _compressImage(file);

      if (compressedFile == null) {
        return Error(errorData: const DomainErrorType.errorDefaultType());
      }

      final response = await _supabaseUploadApi.uploadAdvertPhoto(compressedFile.file, compressedFile.thumbBytes);

      await _safeDeleteFile(file);

      return Success(
        data: UploadedImageUrl(imageUrl: response.imageUrl, thumbnailImageUrl: response.thumbnailImageUrl),
      );
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }

  @override
  Future<DomainResultDErr<UploadedFileUrl>> uploadChatFile(File file) async {
    try {
      final response = await _supabaseUploadApi.uploadChatFile(file);

      return Success(data: UploadedFileUrl(fileUrl: response.fileUrl));
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to upload chat file", exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }

  @override
  Future<EmptyDomainResult> uploadChatVoice(File file, String ttsStorageKey) async {
    try {
      await _supabaseUploadApi.uploadChatVoice(file, ttsStorageKey);

      return Success(data: null);
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to upload chat voice", exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }

  @override
  Future<DomainResultDErr<UploadedImageUrl>> uploadChatImage(File file) async {
    try {
      final compressedFile = await _compressImage(file);

      if (compressedFile == null) {
        return Error(errorData: const DomainErrorType.errorDefaultType());
      }

      final response = await _supabaseUploadApi.uploadChatImage(compressedFile.file, compressedFile.thumbBytes);

      await _safeDeleteFile(file);

      return Success(
        data: UploadedImageUrl(imageUrl: response.imageUrl, thumbnailImageUrl: response.thumbnailImageUrl),
      );
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to upload chat image", exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }

  Future<CompressedFile?> _compressImage(File file) async {
    final compressedFile = await compressImage(file);
    final compressedThumbBytes = await compressImageBytes(file);

    if (compressedFile == null || compressedThumbBytes == null) {
      return null;
    }

    final originalFileSize = await file.length();
    final size = await compressedFile.length();

    _logger.log(LogLevel.info, "Original image: ${file.path} — ${_getSizeMb(originalFileSize)}");
    _logger.log(LogLevel.info, "Compressed image: ${compressedFile.path} — ${_getSizeMb(size)}");
    _logger.log(LogLevel.info, "Thumbnail image: ${_getSizeMb(compressedThumbBytes.length)}");

    return (file: File(compressedFile.path), thumbBytes: compressedThumbBytes);
  }

  String _getSizeMb(int size) {
    final sizeInMB = size / (1024 * 1024);

    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  Future<void> _safeDeleteFile(File file) async {
    try {
      await file.delete();
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to delete file", exception: e);
    }
  }
}

typedef CompressedFile = ({File file, Uint8List thumbBytes});
