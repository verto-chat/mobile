import 'package:context_di/context_di.dart';

import 'presentation/manager/home_bloc.dart';

export 'presentation/presentation.dart';

part 'home.g.dart';

@Feature()
@Factory(HomeBloc)
class HomeFeature extends FeatureDependencies with _$HomeFeatureMixin {
  const HomeFeature({super.key, super.builder});
}
