import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';

class AppleAuthResult {
  final String nonce;
  final AuthorizationCredentialAppleID user;

  AppleAuthResult({required this.nonce, required this.user});
}

class AppleSignInProvider {
  final SupabaseClient _supabase;
  final ILogger _logger;

  AppleSignInProvider(this._supabase, this._logger);

  Future<AppleAuthResult> authenticate() async {
    final rawNonce = _supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    return AppleAuthResult(
      nonce: rawNonce,
      user: await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashedNonce,
      ),
    );
  }

  Future<DomainResultDErr<User>> signIn(String idToken, String rawNonce) async {
    try {
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      return Success(data: response.user!);
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }
}
