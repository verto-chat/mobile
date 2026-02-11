import 'package:context_di/context_di.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import 'data/data.dart';
import 'domain/create_chats_repository.dart';
import 'presentation/manager/create_local_chat_sm.dart';

export 'presentation/presentation.dart';

part 'create.g.dart';

@Feature()
@Singleton(CreateChatsRepository, as: ICreateChatsRepository)
@Factory(CreateLocalChatStateManager)
class CreateChatsFeature extends FeatureDependencies with _$CreateChatsFeatureMixin {
  const CreateChatsFeature({super.key, super.child});

  @override
  List<Registration> register() {
    return [registerSingleton((context) => context.read<Openapi>().getChatsApi()), ...super.register()];
  }
}
