import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../core.dart';
import '../../../app_settings/data/supabase_app_settings_api.dart';
import '../pages/pages.dart';

class ServiceButton extends StatelessWidget {
  const ServiceButton({super.key, this.version, this.padding = const EdgeInsets.all(0.0)});

  final String? version;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseAppSettingsApi>(create: (c) => SupabaseAppSettingsApi(c.read())),
        Provider<IAppSettingsRepository>(create: (c) => AppSettingsRepository(c.read(), c.read(), c.read())),
      ],
      builder: (context, _) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () => _onLongPress(context),
        child: Padding(
          padding: padding,
          child: version?.isNotEmpty ?? false
              ? Text(context.appTexts.profile.version(version: version!))
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _adaptiveAction({required BuildContext context, required VoidCallback onPressed, required Widget child}) {
    final ThemeData theme = Theme.of(context);

    return switch (theme.platform) {
      TargetPlatform.iOS => CupertinoDialogAction(onPressed: onPressed, child: child),
      _ => TextButton(onPressed: onPressed, child: child),
    };
  }

  void _onLongPress(BuildContext context) async {
    final appSettingsRepository = context.read<IAppSettingsRepository>();
    final deviceIdProvider = context.read<DeviceIdProvider>();
    final navigator = Navigator.of(context);

    final appSettings = await appSettingsRepository.getSettings();

    if (!context.mounted) return;

    if (kDebugMode || appSettings?.hasInternalAccess == true) {
      navigator.push(MaterialPageRoute<dynamic>(builder: (context) => const ServiceScreen()));
      return;
    }

    if (appSettings == null) {
      await appSettingsRepository.getSettings();
      return;
    }

    final deviceId = deviceIdProvider.deviceId;

    await showAdaptiveDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('DeviceId'),
          content: Text(deviceId ?? 'not found'),
          actions: [
            _adaptiveAction(
              context: context,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: deviceId ?? ''));
                navigator.pop();
              },
              child: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }
}
