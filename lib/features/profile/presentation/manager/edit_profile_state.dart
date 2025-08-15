part of 'edit_profile_bloc.dart';

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default("") String firstName,
    @Default(null) String? lastName,
    @Default(true) bool isShimmerLoading,
    @Default(false) bool isLoading,
    @Default(false) bool canSave,
    @Default(false) bool isFailure,
  }) = _EditProfileState;
}
