import 'package:context_di/context_di.dart';

import 'data/repositories/repositories.dart';
import 'data/supabase/supabase_legal_api.dart';
import 'domain/domain.dart';
import 'presentation/manager/legal_bloc.dart';

export 'presentation/presentation.dart';

part 'legal.g.dart';

@Feature()
@Singleton(SupabaseLegalApi)
@Singleton(LegalRepository, as: ILegalRepository)
@Factory(LegalBloc)
class LegalFeature extends FeatureDependencies with _$LegalFeatureMixin {
  const LegalFeature({super.key, super.builder});
}
