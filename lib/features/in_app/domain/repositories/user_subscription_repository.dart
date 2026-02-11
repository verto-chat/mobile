import '../../../../../common/common.dart';
import '../../../../../features/in_app/domain/entities/entities.dart';

abstract interface class IUserSubscriptionRepository {
  Stream<UserSubscriptionInfo> get subscriptionChangesStream;

  Future<DomainResultDErr<UserSubscriptionInfo>> getSubscription();
}
