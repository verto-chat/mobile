import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../router/app_router.dart';
import 'lang_bloc.dart';
import 'languages_list_view.dart';

@RoutePage()
class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key, required this.onResult});

  final ResultCallback onResult;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LangBloc(context, context.read()),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<LangBloc, LangState>(
          builder: (context, state) {
            return LanguagesListView(
              scrollController: PrimaryScrollController.of(context),
              onLanguageChanged: (locale) async {
                final completer = Completer<void>();
                context.read<LangBloc>().add(LangEvent.changeLanguage(locale: locale, completer: completer));
                await completer.future;
                onResult(true);
              },
            );
          },
        ),
      ),
    );
  }
}
