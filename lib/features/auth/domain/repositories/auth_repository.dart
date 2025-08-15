import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';
import '../entities/entities.dart';

abstract interface class IAuthRepository {
  Stream<AuthStatus> get isStatusChanged;

  AuthStatus get status;

  Future<DomainResultDErr<GoogleLoginResult>> loginByGoogle();

  Future<DomainResultDErr<AppleLoginResult>> loginByApple();

  Future<EmptyDomainResult> completeRegistration(User user);

  Future<DomainResult<void, RegisterErrorResult>> register({
    required String firstName,
    required String? lastName,
    required String email,
    required String password,
  });

  Future<DomainResult<void, LoginErrorResult>> loginByEmail({required String email, required String password});

  Future<EmptyDomainResult> sendResetPasswordCode({required String email});

  Future<DomainResult<ResetCodeStatus, DomainErrorType>> checkResetCode({required String email, required String code});

  Future<EmptyDomainResult> logOut();

  Future<DomainResult<void, DeleteAccountErrorResult>> deleteAccount();

  Future<DomainResult<void, ChangePasswordErrorResult>> changePassword({
    required String currentPassword,
    required String password,
  });

  Future<DomainResult<void, ResetPasswordErrorResult>> resetPassword({required String password});
}
