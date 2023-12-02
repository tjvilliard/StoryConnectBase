import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';

/// All input Widgets ultimately should extend from the Feedback Input Widget
class FeedbackInputWidget extends StatefulWidget {
  const FeedbackInputWidget({super.key});

  @override
  FeedbackInputWidgetState createState() => FeedbackInputWidgetState();
}

class FeedbackInputWidgetState extends State<FeedbackInputWidget> {
  final TextEditingController _feedbackInputController =
      TextEditingController();

  @override
  void dispose() {
    _feedbackInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState state) {
      return Container(
          alignment: Alignment.bottomCenter,
          child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(children: [
                      Expanded(
                          child: Container(
                              constraints: const BoxConstraints(minHeight: 60),
                              child: TextField(
                                  controller: _feedbackInputController,
                                  maxLength: 1000,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      hintText: state.serializer.isSuggestion
                                          ? "Write your Suggestion Here."
                                          : "Write your Comment Here."),
                                  onChanged: (_) {
                                    context.read<FeedbackBloc>().add(
                                        FeedbackEditedEvent(
                                            comment:
                                                _feedbackInputController.text));
                                  }))),
                      Column(children: [
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                tooltip: "Set Annotated Text",
                                icon: const Icon(Icons.message_outlined),
                                onPressed: () {
                                  FeedbackBloc bloc =
                                      context.read<FeedbackBloc>();

                                  ReadingBloc readingBloc =
                                      context.read<ReadingBloc>();

                                  bloc.add(AnnotationChangedEvent(
                                      readingBloc: readingBloc,
                                      offset:
                                          readingBloc.getSelectionBaseOffset(),
                                      offsetEnd: readingBloc
                                          .getSelectionOffsetExtent(),
                                      text: readingBloc.getSelection()));
                                })),
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                tooltip: "Submit Feedback",
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  FeedbackBloc bloc =
                                      context.read<FeedbackBloc>();

                                  bloc.add(SubmitFeedbackEvent(
                                      readingBloc:
                                          context.read<ReadingBloc>()));

                                  _feedbackInputController.clear();
                                }))
                      ])
                    ])),
                state.serializer.selection.text!.isEmpty
                    ? Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Row(children: [
                              Transform.scale(
                                  scale: 0.55,
                                  child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.x),
                                      onPressed: () {
                                        context
                                            .read<FeedbackBloc>()
                                            .add(const ClearAnnotationEvent());
                                      })),
                              const Text("Annotated Text: ")
                            ]),
                            Text(state.serializer.selection.text!),
                          ])
              ]));
    });
  }
}
