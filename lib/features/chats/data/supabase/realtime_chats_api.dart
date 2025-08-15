import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeChatsApi {
  final SupabaseClient _supabase;

  RealtimeChatsApi(this._supabase);

  Stream<List<Map<String, dynamic>>> onChatsChanges({required int limit}) {
    return _supabase
        .from('chat_members')
        .stream(primaryKey: ['id'])
        .eq('user_id', _supabase.auth.currentUser!.id)
        .limit(limit);
  }

  Stream<List<Map<String, dynamic>>> onMessagesChanges({required String chatId, required int limit}) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at', ascending: true)
        .limit(limit);
  }
}
