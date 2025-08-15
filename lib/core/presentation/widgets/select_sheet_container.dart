import 'package:flutter/material.dart';

class SelectSheetContainer extends StatelessWidget {
  const SelectSheetContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
          ),
        ],
      ),
    );
  }
}
