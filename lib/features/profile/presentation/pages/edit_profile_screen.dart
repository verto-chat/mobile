import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../../../i18n/translations.g.dart';
import '../manager/edit_profile_bloc.dart';

@RoutePage()
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile.edit_profile_screen;

    final safeArea = MediaQuery.of(context).padding;

    return BlocProvider(
      create: (_) => EditProfileBloc(context, context.read())..add(const EditProfileEvent.started()),
      child: Scaffold(
        appBar: AppBar(title: Text(loc.title)),
        body: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            return _Content(state);
          },
        ),
        bottomSheet: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: safeArea.bottom),
          child: const _Footer(),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile.edit_profile_screen;

    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: FilledButton(
            onPressed: state.canSave
                ? () {
                    context.read<EditProfileBloc>().add(const EditProfileEvent.saveChanges());
                  }
                : null,
            child: Text(loc.save_button_text),
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.state);

  final EditProfileState state;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.profile.edit_profile_screen;

    if (state.isFailure) {
      return TryAgainButton(
        tryAgainAction: () {
          context.read<EditProfileBloc>().add(const EditProfileEvent.started());
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
          if (state.isShimmerLoading)
            CustomShimmer(child: TextFormField())
          else
            _TextField(
              onChanged: (value) => context.read<EditProfileBloc>().add(EditProfileEvent.changeFirstName(value)),
              value: (state) => state.firstName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "${loc.first_name_label}*", hintText: loc.first_name_label),
            ),
          if (state.isShimmerLoading)
            CustomShimmer(child: TextFormField())
          else
            _TextField(
              onChanged: (value) => context.read<EditProfileBloc>().add(EditProfileEvent.changeLastName(value)),
              value: (state) => state.lastName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: loc.last_name_label, hintText: loc.last_name_label),
            ),
        ],
      ),
    );
  }
}

class _TextField extends StatefulWidget {
  const _TextField({required this.decoration, required this.value, this.onChanged, this.keyboardType});

  final void Function(String)? onChanged;
  final String? Function(EditProfileState value) value;
  final TextInputType? keyboardType;
  final InputDecoration decoration;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final initialState = context.read<EditProfileBloc>().state;
    final initialText = widget.value(initialState) ?? '';
    _controller = TextEditingController(text: initialText);
  }

  void _updateText(String newText) {
    if (newText != _controller.text) {
      final currentSelection = _controller.selection;
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: currentSelection.isValid ? currentSelection : TextSelection.collapsed(offset: newText.length),
        composing: TextRange.empty,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        final newText = widget.value(state) ?? '';
        _updateText(newText);
      },
      child: TextFormField(
        controller: _controller,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }
}
