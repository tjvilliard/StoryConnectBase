import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

/// The input widget for using feedback mode comment.
class FeedbackInputWidget extends StatefulWidget {
  @override
  _FeedbackInputWidgetState createState() => _FeedbackInputWidgetState();
}

class _FeedbackInputWidgetState extends State<FeedbackInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    this._controller.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        builder: (BuildContext context, ChapterBlocStruct chapterState) {
      return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState state) {
          return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(minHeight: 100.0),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Container(
                                      constraints:
                                          BoxConstraints(minHeight: 60.0),
                                      child: TextField(
                                        controller: this._controller,
                                        onChanged: (value) {
                                          if (state.selectedFeedbackType ==
                                              FeedbackType.comment) {
                                            context.read<FeedbackBloc>().add(
                                                CommentEditedEvent(
                                                    comment:
                                                        this._controller.text));
                                          } else {
                                            context.read<FeedbackBloc>().add(
                                                SuggestionEditedEvent(
                                                    suggestion:
                                                        this._controller.text));
                                          }
                                        },
                                        minLines: 1,
                                        maxLines: 5,
                                        maxLength: 1000,
                                        decoration: InputDecoration(
                                            hintText:
                                                state.selectedFeedbackType ==
                                                        FeedbackType.suggestion
                                                    ? "Write a Suggestion..."
                                                    : "Write a Comment..."),
                                      ))),
                              Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 40,
                                      width: 40,
                                      child: IconButton(
                                        onPressed: () {
                                          /*
                                              context.read<FeedbackBloc>().add(
                                                  SubmitFeedbackEvent(
                                                      chapterBloc: context.read<
                                                          ChapterBloc>()));
                                          */
                                        },
                                        icon: Icon(Icons.send),
                                      ))
                                ],
                              )),
                            ]))
                  ]),
                ),
              ));
        },
      );
    });
  }
}
