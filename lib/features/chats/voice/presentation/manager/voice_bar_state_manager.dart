import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:yx_state/yx_state.dart';

part 'voice_bar_state_manager.freezed.dart';

class VoiceResult {
  final String lang;
  final String filePath;
  final Duration duration;

  VoiceResult({required this.lang, required this.filePath, required this.duration});
}

@freezed
sealed class VoiceBarState with _$VoiceBarState {
  const factory VoiceBarState({
    @Default("en") String recordingLanguage,
    @Default(Duration.zero) Duration elapsed,
    @Default(false) bool isRecording,
  }) = _VoiceBarState;
}

class VoiceBarStateManager extends StateManager<VoiceBarState> {
  final AudioRecorder _recorder = AudioRecorder();

  Timer? _ticker;
  DateTime _startedAt = DateTime.now();

  VoiceBarStateManager() : super(const VoiceBarState());

  Future<void> startRecording(String lang) => handle((emit) async {
    HapticFeedback.selectionClick();

    final hasPerm = await _recorder.hasPermission();

    if (!hasPerm) {
      return;
    }

    final path = await _getVoicePath(lang);

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100, numChannels: 1),
      path: path,
    );

    _startedAt = DateTime.now();

    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) => tickRecording());

    emit(VoiceBarState(recordingLanguage: lang, elapsed: Duration.zero, isRecording: true));
  });

  Future<void> stopRecording(String lang, Completer<VoiceResult?> completer) => handle((emit) async {
    _ticker?.cancel();

    final stoppedPath = await _recorder.stop();

    final duration = DateTime.now().difference(_startedAt);

    emit(const VoiceBarState());

    bool isVoiceExists = stoppedPath != null && File(stoppedPath).existsSync();
    bool isShortVoice = duration <= const Duration(milliseconds: 300);

    if (!isVoiceExists || isShortVoice) {
      completer.complete(null);
      return;
    }

    if (!isShortVoice) {
      HapticFeedback.lightImpact();

      completer.complete(VoiceResult(lang: lang, filePath: stoppedPath, duration: duration));
    } else {
      await _safeDeleteVoiceFile(stoppedPath);

      completer.complete(null);
    }
  });

  void tickRecording() => handle((emit) async {
    emit(state.copyWith(elapsed: DateTime.now().difference(_startedAt)));
  });

  Future<String> _getVoicePath(String lang) async {
    final dir = await getTemporaryDirectory();

    final ts = DateTime.now().toIso8601String().replaceAll(':', '-');

    return p.join(dir.path, "verto_${lang}_$ts.m4a");
  }

  Future<void> _safeDeleteVoiceFile(String path) async {
    try {
      await File(path).delete();
    } catch (_) {}
  }
}
