import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../../../../i18n/translations.g.dart';

/// Theme values for [CustomTextMessage].
typedef _LocalTheme = ({
  TextStyle bodyMedium,
  TextStyle labelSmall,
  Color onPrimary,
  Color onSurface,
  Color primary,
  BorderRadiusGeometry shape,
  Color surfaceContainer,
});

/// A widget that displays a regular text message.
///
/// Supports markdown rendering via [GptMarkdown].
class CustomTextMessage extends StatelessWidget {
  /// The text message data model.
  final TextMessage message;

  /// The index of the message in the list.
  final int index;

  /// Padding around the message bubble content.
  final EdgeInsetsGeometry? padding;

  /// Border radius of the message bubble.
  final BorderRadiusGeometry? borderRadius;

  /// Box constraints for the message bubble.
  final BoxConstraints? constraints;

  /// Font size for messages containing only emojis.
  final double? onlyEmojiFontSize;

  /// Background color for messages sent by the current user.
  final Color? sentBackgroundColor;

  /// Background color for messages received from other users.
  final Color? receivedBackgroundColor;

  /// Text style for messages sent by the current user.
  final TextStyle? sentTextStyle;

  /// Text style for messages received from other users.
  final TextStyle? receivedTextStyle;

  /// The color of the links in the sent messages.
  final Color? sentLinksColor;

  /// The color of the links in the received messages.
  final Color? receivedLinksColor;

  /// Text style for the message timestamp and status.
  final TextStyle? timeStyle;

  /// Whether to display the message timestamp.
  final bool showTime;

  /// Whether to display the message status (sent, delivered, seen) for sent messages.
  final bool showStatus;

  /// Position of the timestamp and status indicator relative to the text.
  final TimeAndStatusPosition timeAndStatusPosition;

  /// Insets for the timestamp and status indicator when [timeAndStatusPosition] is [TimeAndStatusPosition.inline].
  final EdgeInsetsGeometry? timeAndStatusPositionInlineInsets;

  /// The callback function to handle link clicks.
  final void Function(String url, String title)? onLinkTap;

  /// The position of the link preview widget relative to the text.
  /// If set to [LinkPreviewPosition.none], the link preview widget will not be displayed.
  /// A [LinkPreviewBuilder] must be provided for the preview to be displayed.
  final LinkPreviewPosition linkPreviewPosition;

  /// The widget to display on top of the message.
  final Widget? topWidget;

  /// Колбэк для ленивой озвучки сообщения (через signedUrl/плеер снаружи).
  /// text/lang — уже подготовлены под текущий видимый фрагмент (оригинал/перевод).
  final Future<void> Function(TextMessage message, {required String text, required String lang})? onPlayTts; // NEW

  const CustomTextMessage({
    super.key,
    required this.message,
    required this.index,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderRadius,
    this.constraints,
    this.onlyEmojiFontSize = 48,
    this.sentBackgroundColor,
    this.receivedBackgroundColor,
    this.sentTextStyle,
    this.receivedTextStyle,
    this.sentLinksColor,
    this.receivedLinksColor,
    this.timeStyle,
    this.showTime = true,
    this.showStatus = true,
    this.timeAndStatusPosition = TimeAndStatusPosition.end,
    this.timeAndStatusPositionInlineInsets = const EdgeInsets.only(bottom: 2),
    this.onLinkTap,
    this.linkPreviewPosition = LinkPreviewPosition.bottom,
    this.topWidget,
    this.onPlayTts,
  });

  bool get _isOnlyEmoji => message.metadata?['isOnlyEmoji'] == true;

  @override
  Widget build(BuildContext context) {
    final theme = context.select(
      (ChatTheme t) => (
        bodyMedium: t.typography.bodyMedium,
        labelSmall: t.typography.labelSmall,
        onPrimary: t.colors.onPrimary,
        onSurface: t.colors.onSurface,
        primary: t.colors.primary,
        shape: t.shape,
        surfaceContainer: t.colors.surfaceContainer,
      ),
    );
    final isSentByMe = context.read<UserID>() == message.authorId;

    final backgroundColor = _resolveBackgroundColor(isSentByMe, theme);
    final paragraphStyle = _resolveParagraphStyle(isSentByMe, theme);
    final timeStyle = _resolveTimeStyle(isSentByMe, theme);

    final timeAndStatus = showTime || (isSentByMe && showStatus)
        ? TimeAndStatus(
            time: message.resolvedTime,
            status: message.resolvedStatus,
            showTime: showTime,
            showStatus: isSentByMe && showStatus,
            textStyle: timeStyle,
          )
        : null;

    final colorScheme = Theme.of(context).colorScheme;

    final textContent = GptMarkdownTheme(
      gptThemeData: GptMarkdownTheme.of(context).copyWith(
        linkColor: isSentByMe ? sentLinksColor : receivedLinksColor,
        linkHoverColor: isSentByMe ? sentLinksColor : receivedLinksColor,
      ),
      child: _TextContent(
        message: message,
        textStyle: _isOnlyEmoji ? paragraphStyle?.copyWith(fontSize: onlyEmojiFontSize) : paragraphStyle,
        actionColor: isSentByMe ? colorScheme.onSurface : colorScheme.tertiary,
        onPlayTts: onPlayTts,
        alignTrailingControlsToEnd: isSentByMe,
        onLinkTap: onLinkTap,
      ),
    );

    final linkPreviewWidget = linkPreviewPosition != LinkPreviewPosition.none
        ? context.read<Builders>().linkPreviewBuilder?.call(context, message, isSentByMe)
        : null;

    return ClipRRect(
      borderRadius: borderRadius ?? theme.shape,
      child: Container(
        constraints: constraints,
        decoration: _isOnlyEmoji ? null : BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: _isOnlyEmoji
                  ? EdgeInsets.symmetric(horizontal: (padding?.horizontal ?? 0) / 2, vertical: 0)
                  : padding,
              child: _buildContentBasedOnPosition(
                context: context,
                textContent: textContent,
                timeAndStatus: timeAndStatus,
                paragraphStyle: paragraphStyle,
                linkPreviewWidget: linkPreviewWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentBasedOnPosition({
    required BuildContext context,
    required Widget textContent,
    TimeAndStatus? timeAndStatus,
    TextStyle? paragraphStyle,
    Widget? linkPreviewWidget,
  }) {
    final textDirection = Directionality.of(context);
    final effectiveLinkPreviewPosition = linkPreviewWidget != null ? linkPreviewPosition : LinkPreviewPosition.none;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ?topWidget,
            if (effectiveLinkPreviewPosition == LinkPreviewPosition.top) linkPreviewWidget!,
            timeAndStatusPosition == TimeAndStatusPosition.inline
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: textContent),
                      const SizedBox(width: 4),
                      Padding(padding: timeAndStatusPositionInlineInsets ?? EdgeInsets.zero, child: timeAndStatus),
                    ],
                  )
                : textContent,
            if (effectiveLinkPreviewPosition == LinkPreviewPosition.bottom) linkPreviewWidget!,
            if (timeAndStatusPosition != TimeAndStatusPosition.inline)
              // Ensure the  width is not smaller than the timeAndStatus widget
              // Ensure the height accounts for it's height
              Opacity(opacity: 0, child: timeAndStatus),
          ],
        ),
        if (timeAndStatusPosition != TimeAndStatusPosition.inline && timeAndStatus != null)
          Positioned.directional(
            textDirection: textDirection,
            end: timeAndStatusPosition == TimeAndStatusPosition.end ? 0 : null,
            start: timeAndStatusPosition == TimeAndStatusPosition.start ? 0 : null,
            bottom: 0,
            child: timeAndStatus,
          ),
      ],
    );
  }

  Color? _resolveBackgroundColor(bool isSentByMe, _LocalTheme theme) {
    if (isSentByMe) {
      return sentBackgroundColor ?? theme.primary;
    }
    return receivedBackgroundColor ?? theme.surfaceContainer;
  }

  TextStyle? _resolveParagraphStyle(bool isSentByMe, _LocalTheme theme) {
    if (isSentByMe) {
      return sentTextStyle ?? theme.bodyMedium.copyWith(color: theme.onPrimary);
    }
    return receivedTextStyle ?? theme.bodyMedium.copyWith(color: theme.onSurface);
  }

  TextStyle? _resolveTimeStyle(bool isSentByMe, _LocalTheme theme) {
    if (isSentByMe) {
      return timeStyle ?? theme.labelSmall.copyWith(color: _isOnlyEmoji ? theme.onSurface : theme.onPrimary);
    }
    return timeStyle ?? theme.labelSmall.copyWith(color: theme.onSurface);
  }
}

class _TextContent extends StatefulWidget {
  const _TextContent({
    required this.message,
    required this.textStyle,
    this.onPlayTts,
    this.alignTrailingControlsToEnd = false,
    this.onLinkTap,
    required this.actionColor,
  });

  final void Function(String url, String title)? onLinkTap;
  final TextMessage message;
  final Color actionColor;
  final TextStyle? textStyle;
  final Future<void> Function(TextMessage message, {required String text, required String lang})? onPlayTts; // NEW
  final bool alignTrailingControlsToEnd;

  @override
  State<_TextContent> createState() => _TextContentState();
}

class _TextContentState extends State<_TextContent> {
  bool isShowOriginal = false;
  bool _isPlaying = false; // NEW (пока идёт запрос/старт озвучки)

  String _currentText() {
    final originalText = widget.message.metadata?["original"] as String? ?? widget.message.text;
    return !isShowOriginal ? widget.message.text : originalText;
  }

  String _currentLang() {
    // Пытаемся считать языки из метаданных
    final originalLang = widget.message.metadata?["originalLang"] as String?;
    final translatedLang = widget.message.metadata?["translatedLang"] as String?;
    if (!isShowOriginal) {
      // сейчас показываем перевод
      if (translatedLang != null && translatedLang.isNotEmpty) return translatedLang;
      // запасной вариант: если оригинал ru — перевод sr, иначе ru
      if ((originalLang ?? '').toLowerCase() == 'ru') return 'sr';
      return 'ru';
    } else {
      // сейчас показываем оригинал
      if (originalLang != null && originalLang.isNotEmpty) return originalLang;
      return 'ru';
    }
  }

  Future<void> _handlePlay() async {
    if (widget.onPlayTts == null || _isPlaying) return;
    final loc = context.appTexts.chats.chat_page;
    setState(() => _isPlaying = true);
    try {
      await widget.onPlayTts!(widget.message, text: _currentText(), lang: _currentLang());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.tts_play_failed(error: e.toString()))));
      }
    } finally {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTranslated = widget.message.metadata?["hasTranslated"] as bool? ?? false;
    final loc = context.appTexts.chats.chat_page;

    final textWidget = GptMarkdown(_currentText(), style: widget.textStyle, onLinkTap: widget.onLinkTap);

    final controls = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.alignTrailingControlsToEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (hasTranslated)
          GestureDetector(
            onTap: () => setState(() => isShowOriginal = !isShowOriginal),
            child: Text(
              isShowOriginal ? loc.return_translation : loc.show_original,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: widget.actionColor),
            ),
          ),
        if (widget.onPlayTts != null) ...[
          if (hasTranslated) const SizedBox(width: 12),
          _PlayButton(
            isBusy: _isPlaying,
            onPressed: _handlePlay,
            color: widget.actionColor,
            tooltip: isShowOriginal ? loc.tts_play_original : loc.tts_play_translation,
          ),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [textWidget, const SizedBox(height: 6), controls],
    );
  }
}

// Небольшая кнопка с лоадером
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isBusy, required this.onPressed, required this.color, required this.tooltip});

  final bool isBusy;
  final VoidCallback onPressed;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final icon = isBusy
        ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: color))
        : Icon(Icons.play_arrow_rounded, size: 20, color: color);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isBusy ? null : onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Padding(padding: const EdgeInsets.all(4), child: icon),
      ),
    );
  }
}
