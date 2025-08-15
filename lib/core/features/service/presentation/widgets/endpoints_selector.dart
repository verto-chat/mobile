import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core.dart';
import '../models/models.dart';

class EndpointsSelector extends StatefulWidget {
  const EndpointsSelector({super.key});

  @override
  State<EndpointsSelector> createState() => _EndpointsSelectorState();
}

class _EndpointsSelectorState extends State<EndpointsSelector> {
  late final EndpointsManager endpointsManager;
  late final List<IEndpoints> endpointsList;

  IEndpoints? _selectedEndpoints;
  IEndpoints? _currentEndpoints;
  bool _isLoading = false;
  Message? _message;

  bool get _hasChanged => _selectedEndpoints != _currentEndpoints;

  @override
  void initState() {
    super.initState();

    endpointsManager = context.read<EndpointsManager>();
    endpointsList = endpointsManager.endpointsList;
    endpointsManager.getEndpoints().then((current) {
      setState(() {
        _currentEndpoints = current;
        _selectedEndpoints = endpointsList[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: const Text("Select endpoints"),
      subtitle: Text("Current endpoints: ${_endpointsToString(_currentEndpoints)}"),
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      children: [
        SizedBox(
          height: 100,
          child: CupertinoPicker(
            itemExtent: 30,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedEndpoints = endpointsList[index];
                _resetMessage();
              });
            },
            children: endpointsList.map((e) => Center(child: Text(_endpointsToString(e)))).toList(),
          ),
        ),
        CupertinoButton(
          onPressed: _isLoading || !_hasChanged ? null : _saveButtonPressed,
          child: _isLoading ? const CircularProgressIndicator() : const Text("Save"),
        ),
        if (_message case Message(:final text, :final isError))
          _EndpointsPickerMessage(message: text, isError: isError),
      ],
    );
  }

  void _saveButtonPressed() async {
    _resetMessage();
    setState(() => _isLoading = true);
    final set = await endpointsManager.setEndpoints(_selectedEndpoints!);
    setState(() => _isLoading = false);

    if (set) {
      _currentEndpoints = _selectedEndpoints;
      _message = successMessage;
      return;
    }

    _message = errorMessage;
  }

  void _resetMessage() {
    _message = null;
  }

  String _endpointsToString(IEndpoints? endpoints) {
    return switch (endpoints) {
      ProductionEndpoints() => "Production",
      PreReleaseEndpoints() => "Pre-release",
      null => '',
    };
  }
}

class _EndpointsPickerMessage extends StatelessWidget {
  const _EndpointsPickerMessage({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      message,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isError ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
    );
  }
}
