import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

class SupabaseReportApi {
  final SupabaseClient _supabase;

  SupabaseReportApi(this._supabase);

  Future<void> report(ReportRequestDto request) async {
    final currentUserId = _supabase.auth.currentUser!.id;
    
    await _supabase.from('reports').insert({
      'reporter_id': currentUserId,
      'target_type': switch (request.targetType) {
        TargetTypeDto.advert => 'advert',
        TargetTypeDto.chatMessage => 'chat_message',
      },
      'advert_id': switch (request.targetType) {
        TargetTypeDto.advert => request.targetId,
        TargetTypeDto.chatMessage => null,
      },
      'chat_message_id': switch (request.targetType) {
        TargetTypeDto.advert => null,
        TargetTypeDto.chatMessage => request.targetId,
      },
      'reason': switch (request.reason) {
        ReportReasonDto.spam => 'spam',
        ReportReasonDto.inappropriate => 'inappropriate',
        ReportReasonDto.abuse => 'abuse',
        ReportReasonDto.other => 'other',
      },
      'description': request.description,
    });
  }
}
