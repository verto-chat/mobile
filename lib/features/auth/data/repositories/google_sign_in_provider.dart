import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';

const _googleScopes = ["email", "openid", "profile"];

const _webClientId = '702476548325-ougll3a7re1vcrfqd5jn21vun88ripc0.apps.googleusercontent.com';
const _iosClientId = '702476548325-j7adhk03g6iurpfg6q0p48p88b192k8p.apps.googleusercontent.com';

class GoogleSignInProvider {
  final SupabaseClient _supabase;
  final ILogger _logger;

  GoogleSignInProvider(this._supabase, this._logger);

  Future<GoogleSignInAccount> authenticate() async {
    final googleSignIn = await _getGoogleSignIn();

    return await googleSignIn.authenticate(scopeHint: _googleScopes);
  }

  Future<DomainResultDErr<User>> signIn(GoogleSignInAccount googleAccount) async {
    try {
      final authClient = await googleAccount.authorizationClient.authorizationForScopes(_googleScopes);

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAccount.authentication.idToken!,
        accessToken: authClient!.accessToken,
      );

      return Success(data: response.user!);
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  GoogleSignIn? _googleSignIn;

  Future<GoogleSignIn> _getGoogleSignIn() async {
    if (_googleSignIn != null) return _googleSignIn!;

    await GoogleSignIn.instance.initialize(clientId: _iosClientId, serverClientId: _webClientId);

    _googleSignIn = GoogleSignIn.instance;

    return GoogleSignIn.instance;
  }
}
