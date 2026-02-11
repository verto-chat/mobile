import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../router/app_router.dart';
import '../../../chats/chats.dart';

@RoutePage()
class SelectChatTypePage extends StatefulWidget {
  const SelectChatTypePage({super.key});

  @override
  State<SelectChatTypePage> createState() => _SelectChatTypePageState();
}

class _SelectChatTypePageState extends State<SelectChatTypePage> {
  ChatType _selected = ChatType.local;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.chats.select_chat_type_page;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.title),
        leading: IconButton(
          onPressed: () => context.router.parentAsStackRouter?.maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                children: [
                  _ChatTypeCard(
                    type: ChatType.local,
                    selected: _selected == ChatType.local,
                    available: _isAvailable(ChatType.local),
                    onTap: () => setState(() => _selected = ChatType.local),
                  ),
                  _ChatTypeCard(
                    type: ChatType.learning,
                    selected: _selected == ChatType.learning,
                    available: _isAvailable(ChatType.learning),
                    onTap: () => setState(() => _selected = ChatType.learning),
                  ),
                  _ChatTypeCard(
                    type: ChatType.direct,
                    selected: _selected == ChatType.direct,
                    available: _isAvailable(ChatType.direct),
                    onTap: () => setState(() => _selected = ChatType.direct),
                  ),
                  _ChatTypeCard(
                    type: ChatType.group,
                    selected: _selected == ChatType.group,
                    available: _isAvailable(ChatType.group),
                    onTap: () => setState(() => _selected = ChatType.group),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isAvailable(_selected) ? () => context.router.push(const CreateLocalChatRoute()) : null,
                    child: Text(loc.continue_button),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAvailable(ChatType t) => t == ChatType.local;
}

class _ChatTypeCard extends StatelessWidget {
  const _ChatTypeCard({required this.type, required this.selected, required this.onTap, this.available = false});

  final ChatType type;
  final bool selected;
  final VoidCallback onTap;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.appTexts.chats.select_chat_type_page;

    final title = switch (type) {
      ChatType.direct => loc.types.direct,
      ChatType.group => loc.types.group,
      ChatType.local => loc.types.local,
      ChatType.learning => loc.types.learning,
    };

    final icon = switch (type) {
      ChatType.direct => Icons.person_outline,
      ChatType.group => Icons.groups_outlined,
      ChatType.local => Icons.phone_android,
      ChatType.learning => Icons.school_outlined,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 12),
      constraints: BoxConstraints(minHeight: selected ? 220 : 64),
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? theme.colorScheme.primary : theme.dividerColor, width: selected ? 1.6 : 1),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: selected ? 16 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: selected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),

                  if (!available) const _SoonTag(),
                ],
              ),

              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 4, bottom: 2),
                  child: DetailsContent(chatType: type),
                ),
                crossFadeState: selected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
                sizeCurve: Curves.easeOutCubic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoonTag extends StatelessWidget {
  const _SoonTag();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(context.appTexts.chats.select_chat_type_page.soon_tag, style: theme.textTheme.labelSmall),
    );
  }
}

class _CardDetails {
  const _CardDetails({required this.forWhom, required this.canDo, required this.scenarios});

  final String forWhom;
  final String canDo;
  final String scenarios;
}

class DetailsContent extends StatelessWidget {
  const DetailsContent({super.key, required this.chatType});

  final ChatType chatType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.appTexts.chats.select_chat_type_page;
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final valueStyle = theme.textTheme.bodyMedium;
    final details = switch (chatType) {
      ChatType.direct => _CardDetails(
        forWhom: loc.details.direct.for_whom,
        canDo: loc.details.direct.can_do,
        scenarios: loc.details.direct.scenarios,
      ),
      ChatType.group => _CardDetails(
        forWhom: loc.details.group.for_whom,
        canDo: loc.details.group.can_do,
        scenarios: loc.details.group.scenarios,
      ),
      ChatType.local => _CardDetails(
        forWhom: loc.details.local.for_whom,
        canDo: loc.details.local.can_do,
        scenarios: loc.details.local.scenarios,
      ),
      ChatType.learning => _CardDetails(
        forWhom: loc.details.learning.for_whom,
        canDo: loc.details.learning.can_do,
        scenarios: loc.details.learning.scenarios,
      ),
    };

    return Table(
      columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        _row(loc.labels.for_whom, details.forWhom, labelStyle, valueStyle),
        _spacerRow(8),
        _row(loc.labels.can_do, details.canDo, labelStyle, valueStyle),
        _spacerRow(8),
        _row(loc.labels.scenarios, details.scenarios, labelStyle, valueStyle),
      ],
    );
  }

  TableRow _row(String label, String value, TextStyle? l, TextStyle? v) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text('$label:', style: l),
        ),
        Text(value, style: v),
      ],
    );
  }

  TableRow _spacerRow(double h) => TableRow(
    children: [
      SizedBox(height: h),
      SizedBox(height: h),
    ],
  );
}
