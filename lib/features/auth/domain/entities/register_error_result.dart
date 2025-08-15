import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';

part 'register_error_result.freezed.dart';

enum RegisterErrorType {
  other,
  incorrectEmail, //Некорректная эл. почта
  incorrectName, //Некорректное имя
  incorrectPassword, //Некорректный пароль
  emailAlreadyUsed, //Адрес эл. почты уже используется
  createError, //Ошибка при создании пользователя
  emailRateLimitExceeded, //Превышен лимит отправки писем по эл. почте
}

@freezed
sealed class RegisterErrorResult with _$RegisterErrorResult {
  const factory RegisterErrorResult.defaultError(DomainErrorType domainErrorType) = RegisterDefaultError;

  const factory RegisterErrorResult.registerError(RegisterErrorType type) = RegisterError;
}
