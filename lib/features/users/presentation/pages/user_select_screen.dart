import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../manager/user_select_bloc.dart';
import '../widgets/widgets.dart';

typedef SelectUserResult = ({DomainErrorType errorType, String customMessage});

typedef SelectUserDelegate = Future<SelectUserResult?> Function(BuildContext, UserInfo);

class UserSelectScreen extends StatelessWidget {
  const UserSelectScreen({super.key, required this.title, required this.onSelect});

  final String Function(BuildContext) title;
  final SelectUserDelegate onSelect;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserSelectBloc(context, context.read())..add(UserSelectEvent.started(onSelect)),
      child: Scaffold(
        appBar: AppBar(title: Text(title(context))),
        body: BlocBuilder<UserSelectBloc, UserSelectState>(
          builder: (context, state) {
            switch (state) {
              case Loading():
                return const Center(child: CircularProgressIndicator());
              case Loaded(:final users):
                return SimpleLoader(
                  isLoading: state.isLoading,
                  child:
                      users.isEmpty
                          ? Center(child: Text(context.appTexts.users.user_select_screen.empty))
                          : ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              return UserCard(
                                onTap: () => context.read<UserSelectBloc>().add(UserSelectEvent.select(user)),
                                user: user,
                              );
                            },
                          ),
                );
              case Failure():
                return Center(child: Text(context.appTexts.users.user_select_screen.failure));
            }
          },
        ),
      ),
    );
  }
}
