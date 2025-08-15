import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../../common/common.dart';
import '../../../../../common/logger/talker_logger.dart';
import '../widgets/widgets.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(title: Text("Internal access")),
          SliverList.list(
            children: [
              const EndpointsSelector(),
              ListTile(
                trailing: const Icon(Icons.chevron_right),
                title: const Text("Sessions"),
                onTap: () {
                  final navigator = Navigator.of(context);
                  final logger = context.read<ILogger>();

                  if (logger is! TalkerLoggerImpl) return;

                  final loggerImpl = context.read<ILogger>() as TalkerLoggerImpl;

                  navigator.push(
                    MaterialPageRoute<dynamic>(
                      builder: (context) => SessionScreen(
                        openLoggerScreen: (context) => navigator.push(
                          MaterialPageRoute<dynamic>(
                            builder: (context) => TalkerScreen(talker: loggerImpl.talkerInstance),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
