import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Widgets/form_field.dart';

class QuestionEntry extends StatefulWidget {
  const QuestionEntry({Key? key}) : super(key: key);

  @override
  _QuestionEntryState createState() => _QuestionEntryState();
}

class _QuestionEntryState extends State<QuestionEntry> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoadUnblockerBloc, RoadUnblockerState>(
      listener: (context, state) {
        // Update the text controller when the question in the state changes
        if (_textController.text != state.question) {
          _textController.text = state.question ?? ''; // Assuming question is nullable
        }
      },
      builder: (context, state) {
        return CustomFormField(
          controller: _textController,
          label: 'Question',
          onFieldSubmitted: () {
            final WritingBloc writingBloc = context.read<WritingBloc>();
            final WritingUIBloc uiBloc = context.read<WritingUIBloc>();

            final TextSelection selection = uiBloc.state.editorController.selection;
            final String selectedText =
                selection.textInside(writingBloc.state.getCurrentChapterRawText().trim().replaceAll("\\s+", ""));

            context
                .read<RoadUnblockerBloc>()
                .add(SubmitUnblockEvent(selection: selectedText, chapterID: writingBloc.state.currentChapterId));
          },
          onChanged: (value) {
            context.read<RoadUnblockerBloc>().add(OnGuidingQuestionChangedEvent(question: value));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
