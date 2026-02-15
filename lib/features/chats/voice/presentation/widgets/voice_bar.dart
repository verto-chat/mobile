import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yx_state_provider/yx_state_provider.dart';

import '../manager/voice_bar_state_manager.dart';
import 'record_hold_button.dart';

class VoiceBar extends StatelessWidget {
  const VoiceBar({
    super.key,
    required this.onCompleted,
    required this.leftLanguageCode,
    required this.rightLanguageCode,
  });

  final String leftLanguageCode;
  final String rightLanguageCode;

  final void Function(VoiceResult result) onCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: StateManagerProvider(
        create: (_) => VoiceBarStateManager(),
        child: ProviderStateBuilder<VoiceBarStateManager, VoiceBarState>(
          builder: (context, state, child) {
            final isRecordingLeft = state.recordingLanguage == leftLanguageCode && state.isRecording;
            final isRecordingRight = state.recordingLanguage == rightLanguageCode && state.isRecording;

            return Row(
              children: [
                Expanded(
                  child: RecordHoldButton(
                    languageCode: leftLanguageCode,
                    isRecording: isRecordingLeft,
                    elapsed: isRecordingLeft ? state.elapsed : Duration.zero,
                    onLongPressStart: () => context.read<VoiceBarStateManager>().startRecording(leftLanguageCode),
                    onLongPressEnd: () async {
                      Completer<VoiceResult?> completer = Completer<VoiceResult?>();

                      await context.read<VoiceBarStateManager>().stopRecording(leftLanguageCode, completer);

                      final result = await completer.future;

                      if (result != null) onCompleted(result);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RecordHoldButton(
                    languageCode: rightLanguageCode,
                    isRecording: isRecordingRight,
                    elapsed: isRecordingRight ? state.elapsed : Duration.zero,
                    onLongPressStart: () => context.read<VoiceBarStateManager>().startRecording(rightLanguageCode),
                    onLongPressEnd: () async {
                      Completer<VoiceResult?> completer = Completer<VoiceResult?>();

                      await context.read<VoiceBarStateManager>().stopRecording(rightLanguageCode, completer);

                      final result = await completer.future;

                      if (result != null) onCompleted(result);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
