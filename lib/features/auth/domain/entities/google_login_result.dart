import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'google_login_result.freezed.dart';

@freezed
sealed class GoogleLoginResult with _$GoogleLoginResult {
  const factory GoogleLoginResult.registered() = GoogleLoginRegistered;

  const factory GoogleLoginResult.notRegistered({required GoogleSignInAccount googleUser}) = GoogleLoginNotRegistered;
}
