import 'package:context_di/context_di.dart';

import 'data/report_repository.dart';
import 'data/supabase_report_api.dart';
import 'domain/report_repository.dart';

export 'domain/domain.dart';
export 'presentation/presentation.dart';

part 'report.g.dart';

@Feature()
@Singleton(SupabaseReportApi)
@Singleton(ReportRepository, as: IReportRepository)
class ReportFeature extends FeatureDependencies with _$ReportFeatureMixin {
  const ReportFeature({super.key, super.builder});
}
