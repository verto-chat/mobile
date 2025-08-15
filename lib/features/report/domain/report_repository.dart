import '../../../common/common.dart';
import 'entities.dart';

abstract interface class IReportRepository {
  Future<EmptyDomainResult> report(ReportReason reason, String otherReason, TargetType targetType, DomainId targetId);
}
