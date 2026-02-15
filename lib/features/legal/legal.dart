import 'package:context_di/context_di.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../features.dart';
import 'data/repositories/legal_repository.dart';

export 'domain/domain.dart';
export 'presentation/presentation.dart';

part 'legal.g.dart';

@Feature()
@Singleton(LegalRepository, as: ILegalRepository)
@Factory(LegalBloc)
class LegalFeature extends FeatureDependencies with _$LegalFeatureMixin {
  const LegalFeature({super.key, super.builder});

  @override
  List<Registration> register() {
    return [registerSingleton((context) => context.read<Openapi>().getRegulationsApi()), ...super.register()];
  }
}
