import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../i18n/translations.g.dart';
import '../../domain/domain.dart';
import '../../feedback.dart';
import '../manager/feedback_bloc.dart';

@RoutePage()
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key, this.type = FeedbackType.bug});

  final FeedbackType type;

  @override
  Widget build(BuildContext context) {
    final loc = context.appTexts.feedback.feedback_page;
    final textTheme = Theme.of(context).textTheme;

    return FeedbackFeature(
      builder: (context, _) {
        return BlocProvider(
          create: (_) => createFeedbackBloc(context, (type: type)),
          child: Scaffold(
            appBar: AppBar(title: Text(loc.title)),
            body: BlocBuilder<FeedbackBloc, FeedbackState>(
              builder: (context, state) {
                return SimpleLoader(
                  isLoading: state.isLoading,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(loc.type_label, style: textTheme.titleMedium),

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.topLeft,
                          child: DropdownButton<FeedbackType>(
                            value: state.type,
                            style: textTheme.bodyMedium,
                            onChanged: (FeedbackType? value) =>
                                context.read<FeedbackBloc>().add(FeedbackEvent.changeType(value!)),
                            items: FeedbackType.values
                                .map(
                                  (e) => DropdownMenuItem<FeedbackType>(
                                    value: e,
                                    child: Text(switch (e) {
                                      FeedbackType.bug => loc.types.bug,
                                      FeedbackType.feature => loc.types.feature,
                                      FeedbackType.category => loc.types.category,
                                      FeedbackType.question => loc.types.question,
                                      FeedbackType.general => loc.types.general,
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(loc.description_label, style: textTheme.titleMedium),
                        const SizedBox(height: 8),
                        TextFormField(
                          maxLines: 5,
                          maxLength: 300,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: loc.description_hint,
                            errorText: !_textIsNotEmpty(state.description) ? loc.description_error : null,
                          ),
                          onChanged: (v) => context.read<FeedbackBloc>().add(FeedbackEvent.changeDescription(v)),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                        ),

                        const SizedBox(height: 24),

                        FilledButton(
                          onPressed: !_textIsNotEmpty(state.description) || state.isLoading
                              ? null
                              : () => context.read<FeedbackBloc>().add(const FeedbackEvent.sendFeedback()),
                          child: Text(loc.submit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  bool _textIsNotEmpty(String text) {
    return text.trim().isNotEmpty;
  }
}
