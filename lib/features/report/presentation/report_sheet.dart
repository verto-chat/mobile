import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../../i18n/translations.g.dart';
import '../report.dart';

class ReportSheet extends StatefulWidget {
  final TargetType targetType;
  final DomainId targetId;

  const ReportSheet({super.key, required this.targetType, required this.targetId});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  ReportReason? _reason;
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.report.report_sheet;

    return ReportFeature(
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 24),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: RadioGroup<ReportReason>(
                        groupValue: _reason,
                        onChanged: (v) => setState(() => _reason = v),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              loc.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            ...ReportReason.values.map(
                              (r) => RadioListTile<ReportReason>(
                                title: Text(switch (r) {
                                  ReportReason.spam => loc.reasons.spam,
                                  ReportReason.inappropriate => loc.reasons.inappropriate,
                                  ReportReason.abuse => loc.reasons.abuse,
                                  ReportReason.other => loc.reasons.other,
                                }),
                                value: r,
                              ),
                            ),

                            if (_reason == ReportReason.other)
                              TextField(
                                controller: _controller,
                                decoration: InputDecoration(labelText: loc.description_label),
                                minLines: 1,
                                maxLines: 5,
                                maxLength: 300,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.done,
                              ),

                            const SizedBox(height: 8),

                            FilledButton(
                              onPressed: _loading || _reason == null ? null : () => _submit(context.read()),
                              child: _loading
                                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator())
                                  : Text(loc.submit),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(IReportRepository repo) async {
    if (_reason == null) return;

    setState(() => _loading = true);

    final context = this.context;

    final result = await repo.report(_reason!, _controller.text.trim(), widget.targetType, widget.targetId);

    setState(() => _loading = false);

    if (!context.mounted) return;

    switch (result) {
      case Success():
        ToastPresenter.showToast(context: context, message: context.appTexts.report.report_sheet.success);
        context.router.maybePop();

      case Error<void, DomainErrorType>():
        DialogPresenter.showErrorMessage(errorData: result.errorData, context: context);
    }
  }
}
