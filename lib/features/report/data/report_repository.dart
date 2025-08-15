import '../../../common/common.dart';
import '../domain/domain.dart';
import 'models.dart';
import 'supabase_report_api.dart';

class ReportRepository implements IReportRepository {
  final SupabaseReportApi _supabaseReportApi;
  final ILogger _logger;

  ReportRepository(this._supabaseReportApi, this._logger);

  @override
  Future<EmptyDomainResult> report(
    ReportReason reason,
    String otherReason,
    TargetType targetType,
    DomainId targetId,
  ) async {
    try {
      final request = ReportRequestDto(
        targetId: targetId.toString(),
        targetType: TargetTypeDto.fromEntity(targetType),
        reason: ReportReasonDto.fromEntity(reason),
        description: reason == ReportReason.other ? otherReason : null,
      );

      await _supabaseReportApi.report(request);

      return Success(data: null);
    } catch (e) {
      _logger.log(LogLevel.error, "Failed to send report", exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }
}
