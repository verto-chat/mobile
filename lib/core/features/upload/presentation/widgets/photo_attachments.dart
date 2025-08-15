import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core.dart';
import '../manager/upload_file_bloc.dart';
import '../manager/upload_files_bloc.dart';
import 'add_photo_button.dart';
import 'photo_card.dart';

class PhotoAttachments extends StatelessWidget {
  const PhotoAttachments({
    super.key,
    required this.isReadonly,
    required this.controller,
    required this.initFiles,
    required this.onUpdated,
    required this.uploadFunction,
    required this.onLongPressed,
  });

  final UploadFilesController controller;
  final bool isReadonly;
  final List<UploadedImageUrl> Function() initFiles;
  final void Function(List<UploadedImageUrl> files, bool hasLocalFiles) onUpdated;
  final void Function(UploadedFile file, int index) onLongPressed;
  final UploadPhotoFunction uploadFunction;

  @override
  Widget build(BuildContext context) {
    final spacing = 10.0;
    final height = 120.0;

    return SizedBox(
      height: height,
      child: BlocProvider(
        create: (_) => UploadFilesBloc(context, initFiles(), onUpdated, controller),
        child: BlocBuilder<UploadFilesBloc, UploadFilesState>(
          builder: (context, state) {
            final showAddButton = !isReadonly && state.files.length < controller.maxFilesCount;

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: showAddButton ? state.files.length + 1 : state.files.length,
              itemBuilder: (context, index) {
                if (index == state.files.length && showAddButton) {
                  return SizedBox(
                    width: 200,
                    height: height,
                    child: AddPhotoButton(
                      padding: const EdgeInsets.all(12.0),
                      iconSize: 24,
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      onTap: () => context.read<UploadFilesBloc>().add(const UploadFilesEvent.selectFile()),
                    ),
                  );
                }

                final photo = state.files[index];

                return SizedBox(
                  width: 200,
                  height: height,
                  child: PhotoCard(
                    photo: photo,
                    onUploaded: (localFile, uploadedFile) =>
                        context.read<UploadFilesBloc>().add(UploadFilesEvent.uploaded(localFile, uploadedFile, index)),
                    uploadFunction: uploadFunction,
                    onLongPressed: () => onLongPressed(photo, index),
                    onRemoved: () => context.read<UploadFilesBloc>().add(UploadFilesEvent.remove(photo)),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: spacing),
            );
          },
        ),
      ),
    );
  }
}
