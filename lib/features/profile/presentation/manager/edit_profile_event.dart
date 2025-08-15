part of 'edit_profile_bloc.dart';

@freezed
class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.started() = _Started;

  const factory EditProfileEvent.changeFirstName(String firstName) = _ChangeFirstName;

  const factory EditProfileEvent.changeLastName(String lastName) = _ChangeLastName;

  const factory EditProfileEvent.saveChanges() = _SaveChanges;
}
