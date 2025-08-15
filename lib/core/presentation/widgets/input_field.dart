import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.label,
    this.onChanged,
    this.textInputType,
    this.textInputAction,
    this.errorText,
    this.maxLines,
    this.suffixText,
    this.inputFormatters,
  });

  final String label;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextField(
      keyboardType: widget.textInputType,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      decoration: InputDecoration(labelText: widget.label, errorText: widget.errorText, suffixText: widget.suffixText),
      inputFormatters: widget.inputFormatters,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
