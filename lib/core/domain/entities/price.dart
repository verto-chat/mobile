import 'package:formz/formz.dart';

enum PriceValidationError { notValid }

class Price extends FormzInput<String, PriceValidationError> {
  const Price.pure() : super.pure('');

  const Price.dirty([super.value = '']) : super.dirty();

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty) return null;

    if (double.tryParse(value) == null) return PriceValidationError.notValid;

    return null;
  }
}
