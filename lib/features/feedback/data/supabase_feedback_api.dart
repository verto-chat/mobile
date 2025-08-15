import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

class SupabaseFeedbackApi {
  final SupabaseClient _supabase;

  SupabaseFeedbackApi(this._supabase);

  Future<void> sendFeedback(FeedbackRequestDto request) async {
    final currentUserId = _supabase.auth.currentUser!.id;

    await _supabase.from('feedback').insert({
      'user_id': currentUserId,
      'type': switch (request.type) {
        FeedbackTypeDto.bug => 'bug',
        FeedbackTypeDto.feature => 'feature',
        FeedbackTypeDto.category => 'category',
        FeedbackTypeDto.question => 'question',
        FeedbackTypeDto.general => 'general',
      },
      'description': request.description,
    });
  }
}
