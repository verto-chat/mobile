import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../i18n/translations.g.dart';

abstract interface class ICreateChatsRepository {
  Future<DomainResultDErr<DomainId>> createLocalChat({
    required AppLocale myLang,
    required AppLocale partnerLang,
    String? name,
    bool showBothTexts = false,
    bool ttsReadAloud = false,
  });

  Future<DomainResultDErr<DomainId>> createDirectChat(UserInfo user);
}
