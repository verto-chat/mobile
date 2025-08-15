import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/apple_sign_in_provider.dart';

part 'apple_login_result.freezed.dart';

@freezed
sealed class AppleLoginResult with _$AppleLoginResult {
  const factory AppleLoginResult.registered() = AppleLoginRegistered;

  const factory AppleLoginResult.notRegistered({required AppleAuthResult authResult}) = AppleLoginNotRegistered;
}
