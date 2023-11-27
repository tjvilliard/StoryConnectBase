import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_card.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

///
class FeedbackList extends StatefulWidget {
  static const WriterFeedback feedbackItemPlaceholder = WriterFeedback(
    id: 0,
    userId: 1,
    chapterId: 1,
    selection: AnnotatedTextSelection(
        offset: 0, offsetEnd: 0, chapterId: 1, text: "text", floating: false),
    sentiment: FeedbackSentiment.bad,
    isSuggestion: true,
    dismissed: false,
  );

  final List<WriterFeedback> feedbackItems;
  const FeedbackList({super.key, required this.feedbackItems});
  @override
  FeedbackListState createState() => FeedbackListState();
}

///
class FeedbackListState extends State<FeedbackList> {
  List<WriterFeedback> get feedbackItems => widget.feedbackItems;

  ///
  final ScrollController _scrollController = ScrollController();
  late bool showScrollUpButton;
  late bool showScrollDownButton;

  @override
  void initState() {
    showScrollUpButton = false;

    if (feedbackItems.length < 2) {
      showScrollDownButton = false;
    } else {
      showScrollDownButton = true;
    }

    // Check out
    // https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
    // for more
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          showScrollUpButton = false;
        } else {
          showScrollDownButton = false;
        }
      } else {
        showScrollDownButton = true;
        showScrollUpButton = true;
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      if (feedbackItems.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
              style: Theme.of(context).textTheme.bodySmall,
              feedbackState.selectedFeedbackType == FeedbackType.suggestion
                  ? "Nobody has Suggested anything yet, be the first to make a suggestion."
                  : "Nobody has Commented anything yet, be the first to comment."),
        );
      } else {
        return Stack(
          children: [
            Positioned.fill(
                child: ListView.separated(
              itemCount: feedbackItems.length,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, int index) {
                return FeedbackCardWidget(feedback: feedbackItems[index]);
              },
              separatorBuilder: (context, int index) {
                if (index != feedbackItems.length - 1) {
                  return const Divider();
                } else {
                  return Container();
                }
              },
            )),
            Positioned(
                top: 1.0,
                left: 0.0,
                right: 0.0,
                child: Visibility(
                    visible: showScrollUpButton,
                    replacement: const SizedBox.shrink(),
                    child: Container(
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder()),
                            onPressed: () {
                              _scrollController.animateTo(
                                  _scrollController.offset - 200,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: const Icon(FontAwesomeIcons.arrowUp))))),
            Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Visibility(
                    visible: showScrollDownButton,
                    replacement: const SizedBox.shrink(),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder()),
                            onLongPress: () {},
                            onPressed: () {
                              _scrollController.animateTo(
                                  _scrollController.offset + 200,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: const Icon(FontAwesomeIcons.arrowDown)))))
          ],
        );
      }
    });
  }
}
