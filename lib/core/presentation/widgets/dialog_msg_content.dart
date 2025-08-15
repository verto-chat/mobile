import 'package:flutter/material.dart';

import '../dialog/dialog.dart';

class DialogMessageContent<T extends Enum> extends StatelessWidget {
  final DialogInfo<T> _info;

  const DialogMessageContent(this._info, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: _info.titleAlignment,
              child: Text(_info.title, style: Theme.of(context).textTheme.titleLarge),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_info.subtitle != null) Text(_info.subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                    Text(_info.description, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            ...List.generate(_info.actions.length, (index) {
              final action = _info.actions[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: switch (action.actionStyle) {
                  DialogActionStyle.primary => FilledButton(
                    onPressed: () => Navigator.of(context).pop(action.actionType),
                    child: Text(action.actionName),
                  ),
                  DialogActionStyle.secondary => FilledButton.tonal(
                    onPressed: () => Navigator.of(context).pop(action.actionType),
                    child: Text(action.actionName),
                  ),
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
