import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

/// All input Widgets ultimately should extend from the Feedback Input Widget
class FeedbackInputWidget extends StatefulWidget {
  const FeedbackInputWidget({super.key});

  @override
  FeedbackInputWidgetState createState() => FeedbackInputWidgetState();
}

class FeedbackInputWidgetState extends State<FeedbackInputWidget> {
  final TextEditingController _feedbackInputController = TextEditingController();

  @override
  void dispose() {
    _feedbackInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (BuildContext context, FeedbackState state) {
      return Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add_comment),
                          ))
                    ],
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        constraints: const BoxConstraints(minHeight: 60),
                        child: TextField(
                            controller: _feedbackInputController,
                            maxLength: 1000,
                            minLines: 1,
                            maxLines: 5,
                            decoration: const InputDecoration(hintText: "Write your Suggestion Here."),
                            onChanged: (_) {
                              context
                                  .read<FeedbackBloc>()
                                  .add(FeedbackEditedEvent(suggestion: _feedbackInputController.text));
                            }),
                      )),
                      Container(
                          alignment: Alignment.bottomCenter,
                          child: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                context
                                    .read<FeedbackBloc>()
                                    .add(SubmitFeedbackEvent(chapterBloc: context.read<ChapterBloc>()));
                              }))
                    ],
                  )),
            ],
          ));
    });
  }
}
