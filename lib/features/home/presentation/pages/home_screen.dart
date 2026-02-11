import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeFeature(
      builder: (context, _) {
        return BlocProvider(create: (_) => createHomeBloc(context), lazy: false, child: const ChatsPage());
      },
    );
  }
}
