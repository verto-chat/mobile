import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/files/files.dart';
import '../domain/logger_repository.dart';
import '../entities/entities.dart';
import 'widgets/widgets.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key, required this.openLoggerScreen});

  final void Function(BuildContext context) openLoggerScreen;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<IShareLogFileService>(create: (c) => ShareLogFileService(c.read(), c.read(), c.read()))],
      child: FutureBuilder<List<SessionInfo>?>(
        future: context.read<ILoggerRepository>().getSessionsList(),
        builder: (context, state) => Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, _) => [
              SliverAppBar.medium(
                floating: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: GestureDetector(
                      child: const Icon(Icons.book),
                      onTap: () => widget.openLoggerScreen(context),
                    ),
                  ),
                ],
                title: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("Список сессий")),
              ),
            ],
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                if (state.connectionState != ConnectionState.done || _busy) ...[
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                ] else ...[
                  SliverList.separated(
                    itemCount: state.data!.length,
                    itemBuilder: (_, index) {
                      final session = state.data![index];

                      return SessionCard(
                        data: session,
                        onShareTap: () => _onShareTap(session, context.read<IShareLogFileService>()),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onShareTap(SessionInfo session, IShareLogFileService share) async {
    setState(() => _busy = true);

    await share.initService();

    final status = await share.share(session);

    final context = this.context;

    if (!context.mounted) return;

    if (status == ShareActionStatus.noSpaceLeft) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('На устройстве недостаточно памяти.'),
                Text('Пожалуйста, освободите место и повторите попытку.'),
              ],
            ),
          ),
          actions: <Widget>[TextButton(child: const Text('ОК'), onPressed: () => Navigator.of(context).pop())],
        ),
      );
    } else if (status == ShareActionStatus.unknown) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const SingleChildScrollView(child: ListBody(children: [Text('Неизвестная ошибка.')])),
          actions: [TextButton(child: const Text('ОК'), onPressed: () => Navigator.of(context).pop())],
        ),
      );
    }

    setState(() => _busy = false);
  }
}
