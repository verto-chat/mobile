import 'package:context_di/context_di.dart';

import 'data/feedback_repository.dart';
import 'data/supabase_feedback_api.dart';
import 'domain/domain.dart';
import 'presentation/manager/feedback_bloc.dart';

export './presentation/presentation.dart';

part 'feedback.g.dart';

typedef FeedbackBlocParams = ({FeedbackType type});

@Feature()
@Singleton(SupabaseFeedbackApi)
@Singleton(FeedbackRepository, as: IFeedbackRepository)
@Factory(FeedbackBloc, params: FeedbackBlocParams)
class FeedbackFeature extends FeatureDependencies with _$FeedbackFeatureMixin {
  const FeedbackFeature({super.key, super.builder});
}
