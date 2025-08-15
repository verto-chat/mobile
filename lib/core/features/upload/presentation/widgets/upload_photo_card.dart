import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core.dart';
import '../manager/upload_file_bloc.dart';

class UploadPhotoCard extends StatelessWidget {
  UploadPhotoCard({super.key, required this.photo, required this.onUploaded, required this.uploadFunction})
    : file = File(photo.filePath);

  final UploadedLocalFile photo;
  final File file;
  final void Function(UploadedLocalFile loadFile, UploadedImageUrl uploadedPhoto) onUploaded;
  final UploadPhotoFunction uploadFunction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadFileBloc(file, photo, uploadFunction),
      child: BlocConsumer<UploadFileBloc, UploadFileState>(
        listenWhen: (prev, next) => prev is! UploadFileUploaded && next is UploadFileUploaded,
        listener: (context, state) => onUploaded((state as UploadFileUploaded).loadFile, state.uploadedFile),
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.file(file, fit: BoxFit.cover),
              if (state is UploadFileLoading) const Center(child: CircularProgressIndicator()),
              if (state is UploadFileFailure)
                GestureDetector(
                  onTap: () => context.read<UploadFileBloc>().add(const UploadFileEvent.upload()),
                  child: Container(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
                    child: Icon(Icons.replay, color: Theme.of(context).colorScheme.primary, size: 32),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
