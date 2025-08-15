import 'package:formz/formz.dart';

import 'password.dart';

enum ConfirmedPasswordValidationError { empty, notEqual }

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure()
      : original = const Password.pure(),
        super.pure('');

  const ConfirmedPassword.dirty({required this.original, String value = ''}) : super.dirty(value);

  final Password original;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmedPasswordValidationError.empty;

    if (value != original.value) {
      return ConfirmedPasswordValidationError.notEqual;
    }

    return null;
  }
}
