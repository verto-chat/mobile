import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class SupabaseUploadApi {
  final SupabaseClient _supabase;

  SupabaseUploadApi(this._supabase);

  Future<UploadedImageDto> uploadAvatar(File file, Uint8List thumbBytes) {
    return _uploadPhoto(file, thumbBytes, 'avatars');
  }

  Future<UploadedImageDto> uploadAdvertPhoto(File file, Uint8List thumbBytes) {
    return _uploadPhoto(file, thumbBytes, 'shop', folderName: "listings/");
  }

  Future<UploadedFileDto> uploadChatFile(File file) async {
    final extension = file.path.split('.').last;

    final uniqueFileName = const Uuid().v4();
    final storagePath = 'files/$uniqueFileName.$extension';

    final bucket = _supabase.storage.from('chats');

    await bucket.upload(storagePath, file);

    return UploadedFileDto(bucket.getPublicUrl(storagePath));
  }

  Future<void> uploadChatVoice(File file, String ttsStorageKey) async {
    final bucket = _supabase.storage.from("voice");

    await bucket.upload(ttsStorageKey, file);
  }

  Future<UploadedImageDto> uploadChatImage(File file, Uint8List thumbBytes) {
    return _uploadPhoto(file, thumbBytes, 'chats', folderName: "images/");
  }

  Future<UploadedImageDto> _uploadPhoto(
    File file,
    Uint8List thumbBytes,
    String bucketName, {
    String folderName = "",
  }) async {
    final extension = file.path.split('.').last;

    final uniqueFileName = const Uuid().v4();
    final storageOriginalPath = '${folderName}original/$uniqueFileName.$extension';
    final storageThumbPath = '${folderName}thumbnail/$uniqueFileName.$extension';

    await _supabase.storage.from(bucketName).upload(storageOriginalPath, file);
    await _supabase.storage.from(bucketName).uploadBinary(storageThumbPath, thumbBytes);

    return UploadedImageDto(
      _supabase.storage.from(bucketName).getPublicUrl(storageOriginalPath),
      _supabase.storage.from(bucketName).getPublicUrl(storageThumbPath),
    );
  }
}
