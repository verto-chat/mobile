import 'package:context_di/context_di.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import 'data/data_sources/data_sources.dart';
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
      registerSingleton((context) {
        final dio = context.read<CreateDio>().call(context, const (backendSupport: true));

        final endpoints = context.read<IEndpoints>();

        return ChatsApi(dio, baseUrl: "${endpoints.baseUrl}/chats");
      }),

      registerSingleton((context) {
        final dio = context.read<CreateDio>().call(context, const (backendSupport: true));

        final endpoints = context.read<IEndpoints>();

        return ChatMessagesApi(dio, baseUrl: "${endpoints.baseUrl}/chat-messages");
      }),

      ...super.register(),
    ];
  }
}
