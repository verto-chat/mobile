import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../auth/auth.dart';
import '../delete_account_err_to_dialog.dart';
import '../widgets/widgets.dart';

@RoutePage()
class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile.safety_screen;

    return Scaffold(
      appBar: AppBar(title: Text(loc.title)),
      body: SimpleLoader(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              CommonSettingsTitle(
                onTap: null,
                title: "Email",
                value: context.read<SupabaseClient>().auth.currentUser?.email,
                icon: Icons.email,
              ),
              const Divider(),
              CommonSettingsTitle(
                onTap: () =>
                    context.router.push(NewPasswordRoute(navigationPurpose: NewPasswordNavigationPurpose.edit)),
                title: loc.edit_password,
                icon: Icons.password,
              ),
              const Divider(),
              CommonSettingsTitle(onTap: () => _onDeleteAccount(), title: loc.delete_account_label, icon: Icons.delete),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDeleteAccount() async {
    final loc = appTexts.profile.profile_page.delete_confirm;

    final context = this.context;

    final result = await DialogCorePresenter.showMessage(
      context,
      DialogInfo(
        title: loc.title,
        description: loc.description,
        actions: [
          DialogActionInfo<ErrorActionType>(
            actionName: appTexts.core.dialog_action.ok,
            actionType: ErrorActionType.ok,
            actionStyle: DialogActionStyle.secondary,
          ),
          DialogActionInfo<ErrorActionType>(
            actionName: appTexts.core.dialog_action.cancel,
            actionType: ErrorActionType.cancel,
            actionStyle: DialogActionStyle.primary,
          ),
        ],
      ),
    );

    if (result != ErrorActionType.ok) {
      return;
    }

    setState(() => _isLoading = true);

    if (!context.mounted) return;

    final authRepository = context.read<IAuthRepository>();

    final deleteAccResult = await authRepository.deleteAccount();

    switch (deleteAccResult) {
      case Success<void, DeleteAccountErrorResult>():
        break;
      case Error<void, DeleteAccountErrorResult>():
        if (!context.mounted) return;

        await DialogCorePresenter.showMessage(context, deleteAccResult.errorData.toDialog(context));
    }

    setState(() => _isLoading = false);
  }
}
