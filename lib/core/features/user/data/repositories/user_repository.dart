import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../common/common.dart';
import '../../domain/domain.dart';
import '../data.dart';

class UserRepository implements IUserRepository {
  final UserApi _userApi;
  final SafeDio _safeDio;
  final INetworkService _networkService;
  final LocalUserSource _localUserSource;
  final SupabaseClient _supabase;

  UserRepository(this._networkService, this._localUserSource, this._safeDio, this._supabase, this._userApi);

  @override
  DomainId get userId => DomainId.fromString(id: _supabase.auth.currentUser!.id);

  @override
  Future<UserInfo?> getInitUserInfo({required void Function(DomainResultDErr<UserInfo> fresh)? onFreshData}) async {
    final cached = await _localUserSource.getCachedUserInfo();

    final cachedEntity = cached?.toEntity();

    Future.microtask(() async {
      if (await _networkService.isOnline()) {
        final userResult = await getUserInfo();

        switch (userResult) {
          case Success(:final data):
            if (data != cachedEntity) {
              await _localUserSource.cacheUserInfo(UserInfoDto.fromEntity(data));

              onFreshData?.call(Success(data: data));
            }
          case Error<UserInfo, DomainErrorType>():
            onFreshData?.call(userResult);
        }
      }
    });

    return cachedEntity;
  }

  @override
  Future<DomainResultDErr<UserInfo>> getUserInfo() async {
    final apiResult = await _safeDio.execute(() => _userApi.getUser());

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.toEntity()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> updateAvatar({
    required String avatarUrl,
    required String thumbnailAvatarUrl,
    required UserInfo user,
  }) async {
    final request = UpdateUserDto(
      avatarUrl: avatarUrl,
      thumbnailAvatarUrl: thumbnailAvatarUrl,
      firstName: user.firstName,
      lastName: user.lastName,
    );

    final apiResult = await _safeDio.execute(() => _userApi.updateUser(request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<EmptyDomainResult> updateProfile({
    required String firstName,
    required String? lastName,
    required UserInfo user,
  }) async {
    final request = UpdateUserDto(
      firstName: firstName,
      lastName: lastName,
      avatarUrl: user.avatarUrl,
      thumbnailAvatarUrl: user.thumbnailAvatarUrl,
    );

    final apiResult = await _safeDio.execute(() => _userApi.updateUser(request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: null),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }
}
