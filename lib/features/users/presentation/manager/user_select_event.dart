part of 'user_select_bloc.dart';

@freezed
class UserSelectEvent with _$UserSelectEvent {
  const factory UserSelectEvent.started(SelectUserDelegate onSelect) = _Started;

  const factory UserSelectEvent.load({Completer<void>? completer}) = _Load;

  const factory UserSelectEvent.select(UserInfo user) = _Select;
}
