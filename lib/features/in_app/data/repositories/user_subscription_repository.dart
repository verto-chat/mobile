import 'dart:async';

import 'package:openapi/openapi.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../common/common.dart';
import '../../../../../core/core.dart';
import '../../../../../features/auth/auth.dart';
import '../../domain/domain.dart';
import '../data_sources/data_sources.dart';

class UserSubscriptionRepository implements IUserSubscriptionRepository {
  static const String _monetizationInfoEvent = 'MonetizationInfoChanged';

  final ILogger _logger;
  final MonetizationApi _monetizationApi;
  final SupabaseClient _supabase;
  final SafeDio _safeDio;
  final IEndpoints _endpoints;

  final StreamController<UserSubscriptionInfo> _streamController = StreamController.broadcast();

  StreamSubscription<AuthStatus>? _authChangeSubscription;
  HubConnection? _hubConnection;
  bool _isConnecting = false;

  @override
  Stream<UserSubscriptionInfo> get subscriptionChangesStream => _streamController.stream;

  UserSubscriptionRepository(
    this._monetizationApi,
    this._logger,
    this._supabase,
    this._safeDio,
    this._endpoints,
    IAuthRepository authRepository,
  ) {
    _authChangeSubscription = authRepository.isStatusChanged.listen(_handleAuthStatus);
    _handleAuthStatus(authRepository.status);
  }

  @override
  Future<DomainResultDErr<UserSubscriptionInfo>> getSubscription() async {
    final apiResult = await _safeDio.executeReliably(() => _monetizationApi.getUserMonetizationInfo());

    return switch (apiResult) {
      ApiSuccess() => Success(data: apiResult.data.toEntity()),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  void dispose() {
    _logger.log(LogLevel.info, "Disposing UserSubscriptionRepository");
    unawaited(_disconnect());
    _authChangeSubscription?.cancel();
    _streamController.close();
  }

  void _handleAuthStatus(AuthStatus status) {
    switch (status) {
      case Authenticated(:final isRefreshed):
        if (isRefreshed) {
          unawaited(_connect());
        } else {
          unawaited(_disconnect());
        }
      case LoggedOut():
        unawaited(_disconnect());
    }
  }

  Future<void> _connect() async {
    if (_hubConnection != null || _isConnecting) return;

    _isConnecting = true;

    try {
      final token = _supabase.auth.currentSession?.accessToken;

      if (token == null || token.isEmpty) {
        _logger.log(LogLevel.warning, "No auth token for monetization hub connection");
        return;
      }

      final hubUrl = Uri.parse(_endpoints.baseUrl).resolve('/monetization-info').toString();

      final connection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.WebSockets,
              accessTokenFactory: () async => _supabase.auth.currentSession?.accessToken ?? '',
            ),
          )
          .withAutomaticReconnect()
          .build();

      connection.on(_monetizationInfoEvent, _onMonetizationInfoChanged);
      connection.onclose(({error}) {
        _logger.log(LogLevel.warning, "Monetization hub closed", exception: error);
        _hubConnection = null;
      });
      connection.onreconnecting(({error}) {
        _logger.log(LogLevel.warning, "Monetization hub reconnecting", exception: error);
      });
      connection.onreconnected(({connectionId}) {
        _logger.log(LogLevel.info, "Monetization hub reconnected. ConnectionId: $connectionId");
      });

      await connection.start();
      _hubConnection = connection;
      _logger.log(LogLevel.info, "Monetization hub connected");
    } catch (e, st) {
      _logger.log(LogLevel.error, "Failed to connect monetization hub", exception: e, stacktrace: st);
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> _disconnect() async {
    final connection = _hubConnection;
    _hubConnection = null;

    if (connection == null) return;

    try {
      await connection.stop();
      _logger.log(LogLevel.info, "Monetization hub disconnected");
    } catch (e, st) {
      _logger.log(LogLevel.error, "Failed to disconnect monetization hub", exception: e, stacktrace: st);
    }
  }

  void _onMonetizationInfoChanged(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) {
      _logger.log(LogLevel.warning, "Monetization hub event without payload");
      return;
    }

    final rawPayload = arguments.first;
    if (rawPayload == null) {
      _logger.log(LogLevel.warning, "Monetization hub payload is null");
      return;
    }

    try {
      if (rawPayload is UserSubscriptionInfoDto) {
        _streamController.add(rawPayload.toEntity());
        return;
      }

      final payload = _toMap(rawPayload);
      final info = UserSubscriptionInfoDto.fromJson(payload).toEntity();
      _streamController.add(info);
    } catch (e, st) {
      _logger.log(LogLevel.error, "Failed to parse monetization hub payload", exception: e, stacktrace: st);
    }
  }

  Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }

    throw ArgumentError('Unsupported monetization payload type: ${value.runtimeType}');
  }
}
