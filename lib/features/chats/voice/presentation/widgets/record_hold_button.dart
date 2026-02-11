import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../../i18n/translations.g.dart';

class RecordHoldButton extends StatelessWidget {
  const RecordHoldButton({
    super.key,
    required this.languageCode,
    required this.isRecording,
    required this.elapsed,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  });

  final String languageCode;

  final bool isRecording;
  final Duration elapsed;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  String _fmt(Duration d) {
    final s = d.inSeconds;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.blueGrey.shade900;
    final activeColor = Colors.red.shade700;
    final loc = context.appTexts.chats.record_hold_button;

    final bg = isRecording ? activeColor : color;
    final textColor = Colors.white;

    final locale = AppLocaleUtils.parseLocaleParts(languageCode: languageCode);

    final label = getLocaleName(locale);

    final flag = getLocaleIcon(locale, fontSize: 28);

    return Semantics(
      button: true,
      label: loc.semantics_label(label: label),
      child: GestureDetector(
        onLongPressStart: (_) => onLongPressStart(),
        onLongPressEnd: (_) => onLongPressEnd(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (isRecording)
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  flag,

                  Column(
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                      ),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 120),
                        child: isRecording
                            ? Row(
                                key: const ValueKey('rec'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _fmt(elapsed),
                                    style: TextStyle(
                                      color: textColor.withValues(alpha: 0.95),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                loc.hold_to_record,
                                key: const ValueKey('hint'),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 12),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
