import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../common/common.dart';
import '../../domain/domain.dart';

part 'upload_file_bloc.freezed.dart';
part 'upload_file_event.dart';
part 'upload_file_state.dart';

typedef UploadPhotoFunction = Future<DomainResult<UploadedImageUrl, DomainErrorType>> Function(File file);

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final File _file;
  final UploadedLocalFile _localFile;
  final UploadPhotoFunction _uploadFunction;

  UploadFileBloc(this._file, this._localFile, this._uploadFunction) : super(const UploadFileState.initial()) {
    on<_Upload>(_onUpload);

    add(const UploadFileEvent.upload());
  }

  Future<void> _onUpload(_Upload event, Emitter<UploadFileState> emit) async {
    if (state is UploadFileUploaded) return;

    emit(const UploadFileState.loading());

    final result = await _uploadFunction(_file);

    switch (result) {
      case Success():
        emit(UploadFileState.uploaded(loadFile: _localFile, uploadedFile: result.data));
      case Error():
        emit(const UploadFileState.failure());
    }
  }
}
