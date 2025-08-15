part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.editProfile() = _EditProfile;

  const factory ProfileEvent.uploadAvatar() = _UploadAvatar;

  const factory ProfileEvent.logout() = _Logout;

  const factory ProfileEvent.createSupportChat() = _CreateSupportChat;

  const factory ProfileEvent.load({Completer<void>? completer}) = _Load;

  const factory ProfileEvent.freshLoad(DomainResultDErr<UserInfo> fresh) = _FreshLoad;
}
