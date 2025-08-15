import '../../../common/common.dart';
import '../domain/domain.dart';
import 'models.dart';
import 'supabase_feedback_api.dart';

class FeedbackRepository implements IFeedbackRepository {
  final SupabaseFeedbackApi _api;
  final ILogger _logger;

  FeedbackRepository(this._api, this._logger);

  @override
  Future<EmptyDomainResult> sendFeedback(FeedbackType type, String description) async {
    try {
      final request = FeedbackRequestDto(type: FeedbackTypeDto.fromEntity(type), description: description);

      await _api.sendFeedback(request);

      return Success(data: null);
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to send feedback", exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }
}
