import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'upload_presenter.dart';

Future<List<XFile>> pickImages(BuildContext context, {bool isMultiselect = false, int maxCount = 10}) async {
  final imageSource = await selectImage(context);

  if (imageSource == null) return [];

  final ImagePicker picker = ImagePicker();

  if (maxCount > 1 && isMultiselect && imageSource == ImageSource.gallery) {
    final images = await picker.pickMultiImage(requestFullMetadata: !Platform.isIOS, limit: maxCount);

    return images.length > maxCount ? [...images.take(maxCount)] : images;
  }

  final XFile? image = await picker.pickImage(source: imageSource, requestFullMetadata: !Platform.isIOS);

  return image == null ? [] : [image];
}

Future<XFile?> compressImage(File originalFile) async {
  final dir = await getTemporaryDirectory();

  final targetPath = path.join(dir.path, "compressed_${const Uuid().v4()}.jpg");

  return await FlutterImageCompress.compressAndGetFile(
    originalFile.path,
    targetPath,
    quality: 70,
    minWidth: 1080,
    minHeight: 1080,
  );
}

Future<Uint8List?> compressImageBytes(File originalFile) async {
  return await FlutterImageCompress.compressWithFile(originalFile.path, minWidth: 300, minHeight: 300, quality: 80);
}
