import 'package:formz/formz.dart';

enum EmailValidationError { empty, incorrect }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;

    if (value.contains(RegExp(r"[\w-.]+@([\w-]+\.)+[\w-]{2,4}$"))) {
      return null;
    }
    return EmailValidationError.incorrect;
  }
}