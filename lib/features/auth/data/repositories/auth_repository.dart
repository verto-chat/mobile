import 'dart:async';

import 'package:openapi/openapi.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';
import '../../domain/domain.dart';
import '../data.dart';
import 'apple_sign_in_provider.dart';
import 'google_sign_in_provider.dart';

class AuthRepository implements IAuthRepository {
  final SupabaseAuthApi _supabaseAuthApi;
  final AuthApi _authApi;
  final UserApi _userApi;
  final SupabaseClient _supabase;
  final GoogleSignInProvider _googleSignInProvider;
  final AppleSignInProvider _appleSignInProvider;
  final SafeDio _safeDio;

  final ILogger _logger;

  final BehaviorSubject<AuthStatus> _streamController = BehaviorSubject<AuthStatus>(sync: true);

  AuthRepository(
    this._logger,
    this._supabaseAuthApi,
    this._userApi,
    this._authApi,
    this._supabase,
    this._googleSignInProvider,
    this._appleSignInProvider,
    this._safeDio,
  ) {
    final isExpired = _supabase.auth.currentSession?.isExpired ?? true;

    _logger.log(
      LogLevel.info,
      "Supabase AuthRepository ctor started: UserId: ${_supabase.auth.currentUser?.id}. Is expired: $isExpired",
    );

    _streamController.add(
      _supabase.auth.currentUser != null ? Authenticated(isRefreshed: !isExpired) : const LoggedOut(),
    );

    _supabase.auth.onAuthStateChange.listen(_onSupabaseAuthStateChange);
  }

  @override
  Stream<AuthStatus> get isStatusChanged => _streamController.stream;

  @override
  AuthStatus get status => _streamController.value;

  @override
  Future<DomainResultDErr<GoogleLoginResult>> loginByGoogle() async {
    try {
      final googleAccount = await _googleSignInProvider.authenticate();

      final email = googleAccount.email;

      final isRegistered = await _supabaseAuthApi.checkUserRegistered(email: email);

      if (isRegistered) {
        final loginResult = await _googleSignInProvider.signIn(googleAccount);

        switch (loginResult) {
          case Success():
            _streamController.add(const Authenticated(isRefreshed: true));

            return Success(data: const GoogleLoginResult.registered());
          case Error():
            return Error(errorData: const DomainErrorType.errorDefaultType());
        }
      }

      return Success(data: GoogleLoginResult.notRegistered(googleUser: googleAccount));
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  @override
  Future<DomainResultDErr<AppleLoginResult>> loginByApple() async {
    try {
      final authResult = await _appleSignInProvider.authenticate();

      final appleId = authResult.user.userIdentifier!;

      final isRegistered = await _supabaseAuthApi.checkUserRegisteredByAppleId(appleId: appleId);

      if (isRegistered) {
        final loginResult = await _appleSignInProvider.signIn(authResult.user.identityToken!, authResult.nonce);

        switch (loginResult) {
          case Success():
            _streamController.add(const Authenticated(isRefreshed: true));

            return Success(data: const AppleLoginResult.registered());
          case Error():
            return Error(errorData: const DomainErrorType.errorDefaultType());
        }
      }

      return Success(data: AppleLoginResult.notRegistered(authResult: authResult));
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  @override
  Future<EmptyDomainResult> completeRegistration(User user) async {
    final apiResult = await _safeDio.execute(() => _userApi.completeRegistration());

    switch (apiResult) {
      case ApiSuccess():
        _streamController.add(const Authenticated(isRefreshed: true));

        return Success(data: null);
      case ApiError():
        return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  @override
  Future<DomainResult<void, RegisterErrorResult>> register({
    required String firstName,
    required String? lastName,
    required String email,
    required String password,
  }) async {
    final apiResult = await _safeDio.execute(
      () => _authApi.register(
        registerUserRequestDto: RegisterUserRequestDto(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        ),
      ),
    );

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: _getRegisterError(apiResult)),
    };
  }

  RegisterErrorResult _getRegisterError(ApiError<void> apiError) {
    final defaultError = RegisterErrorResult.defaultError(apiError.toDomain());

    final errorData = apiError.getAdditionalDataSafe<Map<String, dynamic>>();

    if (errorData != null) {
      try {
        final model = RegisterErrorDto.fromJson(errorData);

        RegisterErrorType type = switch (model.code) {
          RegisterErrorCodeDto.emailExists => RegisterErrorType.emailAlreadyUsed,
          RegisterErrorCodeDto.invalidEmail => RegisterErrorType.incorrectEmail,
          RegisterErrorCodeDto.weakPassword => RegisterErrorType.incorrectPassword,
          RegisterErrorCodeDto.tooManyRequests => RegisterErrorType.other,
          RegisterErrorCodeDto.unknown => RegisterErrorType.other,
        };

        return RegisterErrorResult.registerError(type);
      } catch (e) {
        _logger.log(LogLevel.error, "Failed get register error model", exception: e);
      }
    }

    return defaultError;
  }

  @override
  Future<DomainResult<void, LoginErrorResult>> loginByEmail({required String email, required String password}) async {
    try {
      await _supabaseAuthApi.loginByPassword(email: email, password: password);

      _streamController.add(const Authenticated(isRefreshed: true));

      return Success(data: null);
    } on AuthException catch (e) {
      _logger.log(LogLevel.warning, e.toString(), exception: e);

      List<LoginErrorType> errors = [];

      if (e.code == 'invalid_credentials') {
        errors.add(LoginErrorType.invalidCredentials);
      } else if (e.code == 'email_not_confirmed') {
        errors.add(LoginErrorType.emailNotConfirmed);
      } else {
        errors.add(LoginErrorType.other);
      }

      return Error(errorData: LoginErrorResult.registerError(errors));
    } on Exception catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const LoginErrorResult.defaultError(DomainErrorType.errorDefaultType()));
    }
  }

  @override
  Future<EmptyDomainResult> sendResetPasswordCode({required String email}) async {
    try {
      await _supabaseAuthApi.sendResetPasswordCode(email: email);
      return Success(data: null);
    } on Exception catch (e) {
      _logger.log(LogLevel.error, "Failed to register", exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  @override
  Future<DomainResult<ResetCodeStatus, DomainErrorType>> checkResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final userId = await _supabaseAuthApi.checkResetCode(email, code);

      if (userId == null) {
        return Success(data: ResetCodeStatus.incorrect);
      }

      return Success(data: ResetCodeStatus.correct);
    } on AuthException catch (e) {
      _logger.log(LogLevel.warning, e.toString(), exception: e);
      if (e.code == 'otp_expired') {
        return Success(data: ResetCodeStatus.incorrect);
      } else {
        return Error(errorData: const DomainErrorType.errorDefaultType());
      }
    } on Exception catch (e) {
      _logger.log(LogLevel.error, "Failed to check reset code", exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }
  }

  @override
  Future<DomainResult<void, ChangePasswordErrorResult>> changePassword({
    required String currentPassword,
    required String password,
  }) async {
    try {
      await _supabaseAuthApi.changePassword(currentPassword: currentPassword, password: password);

      return Success(data: null);
    } on AuthWeakPasswordException catch (e) {
      _logger.log(LogLevel.warning, e.toString(), exception: e);

      return Error(errorData: const ChangePasswordErrorResult.changePassword(ChangePasswordStatus.incorrect));
    } on AuthApiException catch (e) {
      _logger.log(LogLevel.warning, e.toString(), exception: e);

      return Error(
        errorData: ChangePasswordErrorResult.changePassword(switch (e.code) {
          "same_password" => ChangePasswordStatus.samePassword,
          _ => ChangePasswordStatus.wrongCurrentPassword,
        }),
      );
    } on Exception catch (e) {
      _logger.log(LogLevel.error, "Failed to change password", exception: e);
      return Error(errorData: const ChangePasswordErrorResult.defaultError(DomainErrorType.errorDefaultType()));
    }
  }

  @override
  Future<DomainResult<void, ResetPasswordErrorResult>> resetPassword({required String password}) async {
    try {
      await _supabaseAuthApi.resetPassword(password: password);

      return Success(data: null);
    } on AuthWeakPasswordException catch (e) {
      _logger.log(LogLevel.warning, e.toString(), exception: e);

      return Error(errorData: const ResetPasswordErrorResult.changePassword(ResetPasswordStatus.incorrect));
    } on AuthApiException catch (e) {
      _logger.log(LogLevel.warning, e.toString(), exception: e);

      return Error(
        errorData: ResetPasswordErrorResult.changePassword(switch (e.code) {
          "same_password" => ResetPasswordStatus.samePassword,
          _ => ResetPasswordStatus.incorrect,
        }),
      );
    } on Exception catch (e) {
      _logger.log(LogLevel.error, "Failed to reset password", exception: e);
      return Error(errorData: const ResetPasswordErrorResult.defaultError(DomainErrorType.errorDefaultType()));
    }
  }

  @override
  Future<EmptyDomainResult> logOut() async {
    try {
      await _supabaseAuthApi.logOut();

      _streamController.add(const LoggedOut());
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DomainErrorType.errorDefaultType());
    }

    return Success(data: null);
  }

  @override
  Future<DomainResult<void, DeleteAccountErrorResult>> deleteAccount() async {
    try {
      await _supabaseAuthApi.deleteAccount();

      _streamController.add(const LoggedOut());

      return Success(data: null);
    } catch (e) {
      _logger.log(LogLevel.error, e.toString(), exception: e);
      return Error(errorData: const DeleteAccountDefaultError(DomainErrorType.errorDefaultType()));
    }
  }

  void _onSupabaseAuthStateChange(AuthState event) {
    _logger.log(LogLevel.info, "Supabase auth state changed: ${event.event}");

    if (event.event == AuthChangeEvent.tokenRefreshed) {
      _streamController.add(const Authenticated(isRefreshed: true));
    }
  }
}
