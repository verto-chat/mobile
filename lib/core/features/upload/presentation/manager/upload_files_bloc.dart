import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../common/common.dart';
import '../../../../core.dart';

part 'upload_files_bloc.freezed.dart';
part 'upload_files_event.dart';
part 'upload_files_state.dart';

class UploadFilesBloc extends ContextBloc<UploadFilesEvent, UploadFilesState> {
  final bool _isMultiselect = true;
  final void Function(List<UploadedImageUrl> files, bool hasLocalFiles) onUpdated;
  final UploadFilesController controller;

  UploadFilesBloc(BuildContext context, List<UploadedImageUrl> files, this.onUpdated, this.controller)
    : super(UploadFilesState(files: files), context) {
    on<_SelectFile>(_onTakePicture);
    on<_Uploaded>(_onUploaded);
    on<_Remove>(_onRemove);
    on<_MoveFile>(_onMoveFile);

    controller.bind(
      onMoveFile: (f, i) => add(UploadFilesEvent.moveFile(f, i)),
      onRemoveFile: (f) => add(UploadFilesEvent.remove(f)),
    );
  }

  void _onUploaded(_Uploaded event, Emitter<UploadFilesState> emit) {
    final newFiles = state.files.toList();

    final index = newFiles.indexOf(event.loadFile);

    newFiles.removeAt(index);

    newFiles.insert(event.index, event.uploadedFile);

    emit(state.copyWith(files: newFiles));

    final hasLocalFiles = newFiles.any((e) => e is UploadedLocalFile);

    onUpdated(newFiles.whereType<UploadedImageUrl>().toList(), hasLocalFiles);
  }

  void _onRemove(_Remove event, Emitter<UploadFilesState> emit) {
    final newFiles = state.files.where((e) => e != event.file).toList();
    final hasLocalFiles = newFiles.any((e) => e is UploadedLocalFile);

    onUpdated(newFiles.whereType<UploadedImageUrl>().toList(), hasLocalFiles);

    emit(state.copyWith(files: newFiles));
  }

  void _onMoveFile(_MoveFile event, Emitter<UploadFilesState> emit) {
    final newFiles = state.files.where((e) => e != event.file).toList();
    newFiles.insert(event.index, event.file);

    final hasLocalFiles = newFiles.any((e) => e is UploadedLocalFile);

    onUpdated(newFiles.whereType<UploadedImageUrl>().toList(), hasLocalFiles);

    emit(state.copyWith(files: newFiles));
  }

  Future<void> _onTakePicture(_SelectFile event, Emitter<UploadFilesState> emit) async {
    final filesLimit = controller.maxFilesCount - state.files.length;

    if (filesLimit <= 0) {
      return;
    }

    final images = await pickImages(context, isMultiselect: _isMultiselect, maxCount: filesLimit);

    if (images.isEmpty) return;

    emit(
      state.copyWith(
        files: [
          ...state.files,
          ...images.map((e) => UploadedFile.local(filePath: e.path, fileType: FileType.image)),
        ],
      ),
    );
  }
}
