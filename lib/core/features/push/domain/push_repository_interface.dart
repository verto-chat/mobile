import '../../../../common/common.dart';

abstract interface class ITokenRepository {
  Future<EmptyDomainResult> actualize({required String token});

  Future<EmptyDomainResult> archive({required String token});
}
