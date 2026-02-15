import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yx_state_provider/yx_state_provider.dart';

import '../../../../common/common.dart';
import '../../../../core/features/localization/lang_extensions.dart';
import '../../../../i18n/translations.g.dart';
import '../../create.dart';
import '../manager/create_local_chat_sm.dart';

@RoutePage()
class CreateLocalChatPage extends StatelessWidget {
  const CreateLocalChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateManagerProvider(
      create: (c) => createCreateLocalChatStateManager(c),
      child: Scaffold(
        appBar: AppBar(title: Text(context.appTexts.chats.create_local_chat_page.title)),
        body: const _Content(),
        bottomNavigationBar: const _BottomBar(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.chats.create_local_chat_page;
    return ProviderStateBuilder<CreateLocalChatStateManager, CreateLocalChatState>(
      builder: (context, state, _) {
        return SimpleLoader(
          isLoading: state.isLoading,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: loc.title_label,
                  hintText: loc.title_hint,
                ),
                textInputAction: TextInputAction.next,
                onChanged: (newTitle) => context.read<CreateLocalChatStateManager>().setTitle(newTitle),
              ),
              const SizedBox(height: 16),

              _SectionHeader(loc.languages_section),
              const SizedBox(height: 8),
              _LangRow(
                label: loc.my_language_label,
                value: state.myLang,
                languages: supportedLocales,
                onChanged: (v) => context.read<CreateLocalChatStateManager>().setMyLanguage(v),
              ),
              const SizedBox(height: 8),
              _LangRow(
                label: loc.partner_language_label,
                value: state.partnerLang,
                languages: supportedLocales,
                onChanged: (v) => context.read<CreateLocalChatStateManager>().setPartnerLanguage(v),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.read<CreateLocalChatStateManager>().swapLanguages(),
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(loc.swap_languages),
                ),
              ),

              const SizedBox(height: 16),
              _SectionHeader(loc.translation_section),
              const SizedBox(height: 8),

              SwitchListTile.adaptive(
                title: Text(loc.show_both_title),
                subtitle: Text(loc.show_both_subtitle),
                value: state.showBothTexts,
                onChanged: null,
              ),

              SwitchListTile.adaptive(
                title: Text(loc.tts_title),
                subtitle: Text(loc.tts_subtitle),
                value: state.ttsReadAloud,
                onChanged: null,
              ),

              const SizedBox(height: 16),

              _TipsCard(
                title: loc.tips_title,
                tip1: loc.tips_item_1,
                tip2: loc.tips_item_2,
                tip3: loc.tips_item_3,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(text, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600));
  }
}

class _LangRow extends StatelessWidget {
  const _LangRow({required this.label, required this.value, required this.languages, required this.onChanged});

  final String label;
  final AppLocale? value;
  final List<AppLocale> languages;
  final ValueChanged<AppLocale> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(labelText: label),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLocale>(
                value: value,
                isExpanded: true,
                items: [
                  for (final l in languages)
                    DropdownMenuItem(
                      value: l,
                      child: Row(
                        children: [
                          getLocaleIcon(l),
                          const SizedBox(width: 8),
                          Expanded(child: Text(getLocaleName(l), style: theme.textTheme.bodyLarge)),
                        ],
                      ),
                    ),
                ],
                onChanged: (v) => v == null ? null : onChanged(v),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.title, required this.tip1, required this.tip2, required this.tip3});

  final String title;
  final String tip1;
  final String tip2;
  final String tip3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(tip1),
            Text(tip2),
            Text(tip3),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.chats.create_local_chat_page;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ProviderStateBuilder<CreateLocalChatStateManager, CreateLocalChatState>(
            buildWhen: (prev, next) => prev.canCreate != next.canCreate,
            builder: (context, state, _) {
              return FilledButton.icon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(loc.start_button),
                onPressed: state.canCreate ? () => context.read<CreateLocalChatStateManager>().createChat() : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
