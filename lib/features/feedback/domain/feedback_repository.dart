import '../../../common/common.dart';
import 'entities.dart';

abstract interface class IFeedbackRepository {
  Future<EmptyDomainResult> sendFeedback(FeedbackType type, String description);
}