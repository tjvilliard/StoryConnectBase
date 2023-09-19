import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Widgets/form_field.dart';

class QuestionEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadUnblockerBloc, RoadUnblockerState>(
        buildWhen: (previous, current) {
      return previous.question != current.question;
    }, builder: (context, state) {
      return CustomFormField(
          label: 'Question',
          onFieldSubmitted: () {
            context.read<RoadUnblockerBloc>().add(SubmitUnblockEvent());
          },
          onChanged: (value) {
            context
                .read<RoadUnblockerBloc>()
                .add(OnGuidingQuestionChangedEvent(question: value));
          });
    });
  }
}
