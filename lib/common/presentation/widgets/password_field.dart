import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.label, this.errorText, this.onChanged, this.textInputAction});

  final String? label;
  final String? errorText;

  final ValueChanged<String>? onChanged;

  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_passwordVisible,
      onChanged: widget.onChanged,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        suffixIcon: IconButton(
          icon: _passwordVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      textCapitalization: TextCapitalization.none,
      textInputAction: widget.textInputAction,
    );
  }
}
