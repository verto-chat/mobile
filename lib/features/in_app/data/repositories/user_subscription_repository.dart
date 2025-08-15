import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../common/common.dart';
import '../../../../../features/auth/auth.dart';
import '../../domain/domain.dart';
import '../data_sources/user_subscription_api.dart';

class UserSubscriptionRepository implements IUserSubscriptionRepository {
  final ILogger _logger;
  final UserSubscriptionApi _supabaseSubscriptionApi;
  final SupabaseClient _supabase;
  final SafeDio _safeDio;

  final StreamController<dynamic> _streamController = StreamController.broadcast();

  RealtimeChannel? _subscriptionChangesChannel;
  StreamSubscription<AuthStatus>? _authChangeSubscription;

  @override
  Stream<dynamic> get subscriptionChangesStream => _streamController.stream;

  UserSubscriptionRepository(
    this._supabaseSubscriptionApi,
    this._logger,
    this._supabase,
    this._safeDio,
    IAuthRepository authRepository,
  ) {
    final authStatus = authRepository.status;

    switch (authStatus) {
      case Authenticated(:final isRefreshed):
        if (isRefreshed) {
          _subscribe();
        } else {
          _authChangeSubscription = authRepository.isStatusChanged.listen((status) {
            switch (status) {
              case Authenticated(:final isRefreshed):
                if (isRefreshed) {
                  _subscribe();
                }
              case LoggedOut():
                break;
            }
          });
        }
      case LoggedOut():
        break;
    }
  }

  @override
  Future<DomainResultDErr<UserSubscriptionInfo>> getSubscription() async {
    final apiResult = await _safeDio.executeReliably(() => _supabaseSubscriptionApi.getMonetizationInfo());

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.toEntity()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  void dispose() {
    _logger.log(LogLevel.info, "Disposing UserSubscriptionRepository");
    _subscriptionChangesChannel?.unsubscribe();
    _authChangeSubscription?.cancel();
  }

  PostgresChangeFilter _createUserFilter(String column) {
    final userId = _supabase.auth.currentUser?.id;

    return PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: column, value: userId);
  }

  bool _isSubscribed = false;

  void _subscribe() {
    if (_isSubscribed) return;

    _isSubscribed = true;

    try {
      _subscriptionChangesChannel = _supabase
          .channel('subscriptions_changes')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: "subscriptions",
            callback: (payload) => _streamController.add(null),
            filter: _createUserFilter("user_id"),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: "adverts",
            callback: (payload) => _streamController.add(null),
            filter: _createUserFilter("user_id"),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: "users",
            callback: (payload) => _streamController.add(null),
            filter: _createUserFilter("id"),
          )
          .subscribe((status, error) {
            if (status == RealtimeSubscribeStatus.channelError) {
              _logger.log(LogLevel.error, "Error subscribing to subscription changes", exception: error);
            }
          });
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to subscribe to subscription", exception: e);
    }
  }
}
