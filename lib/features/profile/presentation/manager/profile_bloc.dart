import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../auth/auth.dart';
import '../../../chats/chats.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends ContextBloc<ProfileEvent, ProfileState> {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;
  final IChatsRepository _chatsRepository;
  final IUploadRepository _uploadRepository;

  ProfileBloc(
    this._userRepository,
    this._authRepository,
    this._uploadRepository,
    this._chatsRepository,
    VersionProvider versionProvider,
    BuildContext context,
  ) : super(_createInitialState(versionProvider), context) {
    on<_Started>(_onStarted);
    on<_Load>(_onLoad);
    on<_EditProfile>(_onEditProfile);
    on<_UploadAvatar>(_onUploadAvatar);
    on<_Logout>(_onLogout);
    on<_CreateSupportChat>(_onCreateSupportChat);
    on<_FreshLoad>(_onFreshLoad);

    add(const ProfileEvent.started());
  }

  Future<void> _onStarted(_Started event, Emitter<ProfileState> emit) async {
    final cachedUserInfo = await _userRepository.getInitUserInfo(
      onFreshData: (fresh) => {add(ProfileEvent.freshLoad(fresh))},
    );

    if (cachedUserInfo == null) {
      emit(state.copyWith(isShimmerLoading: true));
      return;
    }

    emit(state.copyWith(userInfo: cachedUserInfo, isShimmerLoading: false));
  }

  Future<void> _onFreshLoad(_FreshLoad event, Emitter<ProfileState> emit) async {
    switch (event.fresh) {
      case Success(:final data):
        emit(state.copyWith(userInfo: data, isShimmerLoading: false));
      case Error(:final errorData):
        await showError(errorData, customMessage: appTexts.profile.profile_page.failed_loading_profile);
    }
  }

  Future<void> _onLoad(_Load event, Emitter<ProfileState> emit) async {
    final result = await _userRepository.getUserInfo();

    switch (result) {
      case Success():
        final user = result.data;

        emit(state.copyWith(userInfo: user, isShimmerLoading: false));
      case Error():
        await showError(result.errorData, customMessage: appTexts.profile.profile_page.failed_loading_profile);
    }

    event.completer?.complete();
  }

  Future<void> _onEditProfile(_EditProfile event, Emitter<ProfileState> emit) async {
    await context.router.push(const EditProfileRoute());

    add(const ProfileEvent.load());
  }

  Future<void> _onLogout(_Logout event, Emitter<ProfileState> emit) async {
    await _authRepository.logOut();
  }

  Future<void> _onCreateSupportChat(_CreateSupportChat event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _chatsRepository.createSupportChat();

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        router?.push(ChatRoute(chatId: result.data.id, name: appTexts.chats.chats_page.chat_card.support_chat_name));
      case Error():
        showError(result.errorData, customMessage: appTexts.profile.profile_page.failed_create_support_chat);
    }
  }

  Future<void> _onUploadAvatar(_UploadAvatar event, Emitter<ProfileState> emit) async {
    final images = await pickImages(context);

    if (images.isEmpty) return;

    if (!context.mounted) return;

    final image = images.first;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: appTexts.profile.edit_avatar_title,
          toolbarColor: Theme.of(context).colorScheme.surface,
          toolbarWidgetColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).colorScheme.surface,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          cropStyle: CropStyle.circle,
          statusBarColor: Colors.transparent,
          hideBottomControls: true,
          showCropGrid: false,
        ),
        IOSUiSettings(
          title: appTexts.profile.edit_avatar_title,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          cropStyle: CropStyle.circle,
          aspectRatioLockEnabled: true,
          rotateClockwiseButtonHidden: true,
          resetButtonHidden: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );
    if (croppedFile == null) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final uploadResult = await _uploadRepository.uploadAvatar(File(croppedFile.path));

    switch (uploadResult) {
      case Success():
        final updateResult = await _userRepository.updateAvatar(
          avatarUrl: uploadResult.data.imageUrl,
          thumbnailAvatarUrl: uploadResult.data.thumbnailImageUrl,
          user: state.userInfo,
        );

        switch (updateResult) {
          case Success():
            emit(
              state.copyWith(
                isLoading: false,
                userInfo: state.userInfo.copyWith(
                  avatarUrl: uploadResult.data.thumbnailImageUrl,
                  thumbnailAvatarUrl: uploadResult.data.thumbnailImageUrl,
                ),
              ),
            );
          case Error():
            emit(state.copyWith(isLoading: false));
            showError(updateResult.errorData, customMessage: appTexts.profile.failed_update_avatar);
        }
      case Error():
        emit(state.copyWith(isLoading: false));
        showError(uploadResult.errorData, customMessage: appTexts.profile.failed_upload_avatar);
    }
  }

  static ProfileState _createInitialState(VersionProvider versionProvider) {
    return ProfileState(
      version: "${versionProvider.version}-${versionProvider.buildNumber}",
      userInfo: UserInfo.empty(),
    );
  }
}
