import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';

part 'edit_profile_bloc.freezed.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends ContextBloc<EditProfileEvent, EditProfileState> {
  final IUserRepository _userRepository;
  late UserInfo _userInfo;

  EditProfileBloc(BuildContext context, this._userRepository) : super(const EditProfileState(), context) {
    on<_Started>(_onStarted);
    on<_ChangeFirstName>(_onChangeFirstName);
    on<_ChangeLastName>(_onChangeLastName);
    on<_SaveChanges>(_onSaveChanges);
  }

  Future<void> _onStarted(_Started event, Emitter<EditProfileState> emit) async {
    var result = await _userRepository.getUserInfo();

    switch (result) {
      case Success():
        _userInfo = result.data;

        emit(
          state.copyWith(
            firstName: _userInfo.firstName,
            lastName: _userInfo.lastName,
            isShimmerLoading: false,
            isFailure: false,
          ),
        );
      case Error():
        emit(state.copyWith(isFailure: true));
    }
  }

  void _onChangeFirstName(_ChangeFirstName event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(firstName: event.firstName, canSave: _canSave(event.firstName, state.lastName)));
  }

  void _onChangeLastName(_ChangeLastName event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(lastName: event.lastName, canSave: _canSave(state.firstName, event.lastName)));
  }

  Future<void> _onSaveChanges(_SaveChanges event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(isLoading: true));

    var result = await _userRepository.updateProfile(
      firstName: state.firstName,
      lastName: state.lastName,
      user: _userInfo,
    );

    switch (result) {
      case Success():
        showToast(message: appTexts.profile.edit_profile_screen.success_toast, duration: const Duration(seconds: 2));
        router?.maybePop();
      case Error():
        emit(state.copyWith(isLoading: false, canSave: false));
        showError(result.errorData);
    }
  }

  bool _canSave(String firstName, String? lastName) {
    return firstName.trim().isNotEmpty && !(firstName == _userInfo.firstName && lastName == _userInfo.lastName);
  }
}
