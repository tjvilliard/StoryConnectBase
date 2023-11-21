import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_card.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

///
class FeedbackCardListWidget extends StatefulWidget {
  final List<WriterFeedback> feedbackItems;
  const FeedbackCardListWidget({super.key, required this.feedbackItems});
  @override
  FeedbackCardListState createState() => FeedbackCardListState();
}

///
class FeedbackCardListState extends State<FeedbackCardListWidget> {
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
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (BuildContext context, FeedbackState feedbackState) {
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
                child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: CommentCardWidget.buildAll(feedbackSet: feedbackItems)))),
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
                            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                            onPressed: () {
                              _scrollController.animateTo(_scrollController.offset - 200,
                                  duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
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
                            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                            onLongPress: () {},
                            onPressed: () {
                              _scrollController.animateTo(_scrollController.offset + 200,
                                  duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                            },
                            child: const Icon(FontAwesomeIcons.arrowDown)))))
          ],
        );
      }
    });
  }
}
