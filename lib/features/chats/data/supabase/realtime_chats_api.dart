import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';

class RealtimeChatsApi {
  final SupabaseClient _supabase;
  final ILogger _logger;

  RealtimeChannel? _chatsChangesChannel;

  final StreamController<dynamic> _streamController = StreamController.broadcast();

  Stream<dynamic> get chatsChangesStream => _streamController.stream;

  RealtimeChatsApi(this._supabase, this._logger) {
    _chatsChangesChannel = _supabase
        .channel('subscriptions_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: "chat_members",
          callback: (payload) => _streamController.add(null),
          filter: _createUserFilter("user_id"),
        )
        .subscribe((status, error) {
          if (status == RealtimeSubscribeStatus.channelError) {
            _logger.log(LogLevel.error, "Error subscribing to chats changes", exception: error);
          }
        });
  }

  Stream<List<Map<String, dynamic>>> onMessagesChanges({required String chatId, required int limit}) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at', ascending: true)
        .limit(limit);
  }

  void dispose() {
    _chatsChangesChannel?.unsubscribe();
  }

  PostgresChangeFilter _createUserFilter(String column) {
    final userId = _supabase.auth.currentUser?.id;

    return PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: column, value: userId);
  }
}
