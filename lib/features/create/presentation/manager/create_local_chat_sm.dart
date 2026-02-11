import 'package:context_di/context_di.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../domain/domain.dart';

part 'create_local_chat_sm.freezed.dart';

@freezed
sealed class CreateLocalChatState with _$CreateLocalChatState {
  const factory CreateLocalChatState({
    String? name,
    AppLocale? myLang,
    AppLocale? partnerLang,
    @Default(false) bool showBothTexts,
    @Default(false) bool ttsReadAloud,
    @Default(false) bool isLoading,
    @Default(false) bool canCreate,
  }) = _CreateLocalChatState;
}

class CreateLocalChatStateManager extends ContextStateManager<CreateLocalChatState> {
  final ICreateChatsRepository _repository;

  CreateLocalChatStateManager(BuildContext context, this._repository) : super(const CreateLocalChatState(), context);

  void setTitle(String newTitle) => handle((emit) async {
    emit(state.copyWith(name: newTitle));
  });

  void setMyLanguage(AppLocale language) => handle((emit) async {
    emit(
      state.copyWith(
        myLang: language,
        canCreate: _canCreate(myLanguage: language, partnerLanguage: state.partnerLang),
      ),
    );
  });

  void setPartnerLanguage(AppLocale language) => handle((emit) async {
    emit(
      state.copyWith(
        partnerLang: language,
        canCreate: _canCreate(myLanguage: state.myLang, partnerLanguage: language),
      ),
    );
  });

  void swapLanguages() => handle((emit) async {
    final tmp = state.myLang;

    emit(
      state.copyWith(
        myLang: state.partnerLang,
        partnerLang: tmp,
        canCreate: _canCreate(myLanguage: state.partnerLang, partnerLanguage: tmp),
      ),
    );
  });

  void createChat() => handle((emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await _repository.createLocalChat(
      myLang: state.myLang!,
      partnerLang: state.partnerLang!,
      name: state.name,
      showBothTexts: state.showBothTexts,
      ttsReadAloud: state.ttsReadAloud,
    );

    emit(state.copyWith(isLoading: false));

    switch (result) {
      case Success():
        final parentRouter = router?.parentAsStackRouter;

        await parentRouter?.popAndPush(ChatRoute(chatId: result.data));

      case Error():
        showError(result.errorData);
    }
  });

  bool _canCreate({required AppLocale? myLanguage, required AppLocale? partnerLanguage}) =>
      myLanguage != null && partnerLanguage != null && myLanguage != partnerLanguage;
}
