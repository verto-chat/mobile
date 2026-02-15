import 'package:openapi/openapi.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../i18n/translations.g.dart';
import '../../chats/data/data_sources/data_sources.dart';
import '../domain/domain.dart';

class CreateChatsRepository implements ICreateChatsRepository {
  final ChatsApi _api;
  final SafeDio _safeDio;

  CreateChatsRepository(this._api, this._safeDio);

  @override
  Future<DomainResultDErr<DomainId>> createLocalChat({
    required AppLocale myLang,
    required AppLocale partnerLang,
    String? name,
    bool showBothTexts = false,
    bool ttsReadAloud = false,
  }) async {
    final request = CreateLocalChatRequestDto(
      name: name,
      myLanguageCode: myLang.languageCode.toLanguageCode(),
      partnerLanguageCode: partnerLang.languageCode.toLanguageCode(),
      showBothTexts: showBothTexts,
      ttsReadAloud: showBothTexts,
    );

    final apiResult = await _safeDio.execute(() => _api.createLocalChat(createLocalChatRequestDto: request));

    return switch (apiResult) {
      ApiSuccess() => Success(data: DomainId.fromString(id: apiResult.data.replaceAll('"', ''))),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }

  @override
  Future<DomainResultDErr<DomainId>> createDirectChat(UserInfo user) async {
    final apiResult = await _safeDio.execute(() => _api.createDirectChat(userId: user.id.toString()));

    return switch (apiResult) {
      ApiSuccess() => Success(data: DomainId.fromString(id: apiResult.data)),
      ApiError() => Error(errorData: apiResult.toDomain()),
    };
  }
}
