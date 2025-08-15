import 'package:context_di/context_di.dart';

import 'presentation/manager/profile_bloc.dart';

export 'presentation/presentation.dart';

part 'profile.g.dart';

@Feature()
@Factory(ProfileBloc)
class ProfileFeature extends FeatureDependencies with _$ProfileFeatureMixin {
  const ProfileFeature({super.key, super.child});
}
