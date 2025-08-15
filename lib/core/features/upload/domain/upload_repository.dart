import 'dart:io';

import '../../../../common/common.dart';
import '../../../core.dart';

abstract interface class IUploadRepository {
  Future<DomainResultDErr<UploadedImageUrl>> uploadAvatar(File file);

  Future<DomainResultDErr<UploadedImageUrl>> uploadAdvertPhoto(File file);

  Future<DomainResultDErr<UploadedFileUrl>> uploadChatFile(File file);

  Future<DomainResultDErr<UploadedImageUrl>> uploadChatImage(File file);
}
