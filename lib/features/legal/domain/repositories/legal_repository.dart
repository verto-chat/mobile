import '../../../../common/common.dart';
import '../domain.dart';

abstract interface class ILegalRepository {
  Future<DomainResultDErr<LegalInfo>> getInfo({required String languageCode});
}
