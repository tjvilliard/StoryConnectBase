import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_input/feedback_input.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

class SuggestionInputWidget extends FeedbackInputWidget {
  @override
  _SuggestionInputWidgetState createState() => _SuggestionInputWidgetState();
}

class _SuggestionInputWidgetState extends State<SuggestionInputWidget> {
  TextEditingController _suggestionInputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    this._suggestionInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        builder: (BuildContext context, ChapterBlocStruct chapterState) {
      return BlocBuilder<FeedbackBloc, FeedbackState>(
          builder: (BuildContext context, FeedbackState state) {
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
                              icon: Icon(Icons.add_comment),
                            ))
                      ],
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          constraints: BoxConstraints(minHeight: 60),
                          child: TextField(
                            maxLength: 1000,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: "Write your Suggestion Here."),
                          ),
                        )),
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  context.read<FeedbackBloc>().add(
                                      SubmitFeedbackEvent(
                                          chapterId:
                                              chapterState.chapterIndex));
                                }))
                      ],
                    )),
              ],
            ));
      });
    });
  }
}
