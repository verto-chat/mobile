import '../../../../common/common.dart';
import '../../domain/entities/legal_info.dart';
import '../../domain/repositories/legal_repository.dart';
import '../supabase/supabase_legal_api.dart';

class LegalRepository implements ILegalRepository {
  final SupabaseLegalApi _supabaseLegalApi;
  final ILogger _logger;

  LegalInfo? _cachedInfo;

  LegalRepository(this._supabaseLegalApi, this._logger);

  @override
  Future<DomainResultDErr<LegalInfo>> getInfo({required String languageCode}) async {
    if (_cachedInfo != null && _cachedInfo!.languageCode == languageCode) {
      return Success(data: _cachedInfo!);
    }

    try {
      final data = await _supabaseLegalApi.getInfo(languageCode: languageCode);

      final legalInfo = data.toEntity();

      _cachedInfo = legalInfo;
      
      return Success(data: legalInfo);
    } catch (e) {
      _logger.log(LogLevel.error, 'Failed to get legal info', exception: e);
      return Error(errorData: const DomainErrorType.serverError());
    }
  }
}
