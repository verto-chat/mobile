import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core.dart';
import '../manager/upload_file_bloc.dart';
import '../manager/upload_files_bloc.dart';
import 'add_photo_button.dart';
import 'photo_card.dart';

class BigPhotoAttachments extends StatelessWidget {
  const BigPhotoAttachments({
    super.key,
    required this.controller,
    required this.isReadonly,
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
    final smallHeight = 140.0;

    return BlocProvider(
      create: (_) => UploadFilesBloc(context, initFiles(), onUpdated, controller),
      child: BlocBuilder<UploadFilesBloc, UploadFilesState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final fullWidth = constraints.maxWidth;

              final halfWidth = (fullWidth - spacing) / 2;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  ...List.generate(state.files.length, (index) {
                    final photo = state.files[index];
                    final width = index == 0 ? fullWidth : halfWidth;
                    final height = index == 0 ? 200.0 : smallHeight;

                    return SizedBox(
                      width: width,
                      height: height,
                      child: PhotoCard(
                        photo: photo,
                        onUploaded: (localFile, uploadedFile) => context.read<UploadFilesBloc>().add(
                          UploadFilesEvent.uploaded(localFile, uploadedFile, index),
                        ),
                        uploadFunction: uploadFunction,
                        onLongPressed: () => onLongPressed(photo, index),
                        onRemoved: () => context.read<UploadFilesBloc>().add(UploadFilesEvent.remove(photo)),
                      ),
                    );
                  }),
                  if (!isReadonly && state.files.length < controller.maxFilesCount)
                    SizedBox(
                      width: halfWidth,
                      height: smallHeight,
                      child: AddPhotoButton(
                        onTap: () => context.read<UploadFilesBloc>().add(const UploadFilesEvent.selectFile()),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
