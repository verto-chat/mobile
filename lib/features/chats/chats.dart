import 'package:context_di/context_di.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import 'data/repositories/repositories.dart';
import 'data/supabase/supabase.dart';
import 'domain/domain.dart';

export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';

part 'chats.g.dart';

@Feature()
@Singleton(RealtimeChatsApi)
@Singleton(ChatsRepository, as: IChatsRepository)
class ChatsFeature extends FeatureDependencies with _$ChatsFeatureMixin {
  const ChatsFeature({super.key, super.builder, super.child});

  @override
  List<Registration> register() {
    return [
      registerSingleton((context) => context.read<Openapi>().getChatsApi()),
      registerSingleton((context) => context.read<Openapi>().getChatMessagesApi()),

      ...super.register(),
    ];
  }
}
