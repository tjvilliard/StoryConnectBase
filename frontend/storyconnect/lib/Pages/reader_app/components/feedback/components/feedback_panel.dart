import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_card.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

///
class FeedbackCardListWidget extends StatefulWidget {
  final List<WriterFeedback> feedbackItems;
  FeedbackCardListWidget({required this.feedbackItems});
  @override
  _FeedbackCardListState createState() =>
      _FeedbackCardListState(feedbackItems: this.feedbackItems);
}

///
class _FeedbackCardListState extends State<FeedbackCardListWidget> {
  List<WriterFeedback> feedbackItems;

  ///
  ScrollController _scrollController = ScrollController();
  late bool showScrollUpButton;
  late bool showScrollDownButton;

  _FeedbackCardListState({required this.feedbackItems});

  @override
  void initState() {
    this.showScrollUpButton = false;

    if (this.feedbackItems.isEmpty) {
      this.showScrollDownButton = false;
    } else {
      this.showScrollDownButton = true;
    }

    // Check out
    // https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
    // for more
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          this.showScrollUpButton = false;
        } else {
          this.showScrollDownButton = false;
        }
      } else {
        this.showScrollDownButton = true;
        this.showScrollUpButton = true;
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      return Stack(
        children: [
          Positioned.fill(
              child: SingleChildScrollView(
            controller: this._scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              children: CommentCardWidget.sampleCards(5),
            ),
          )),
          Positioned(
              top: 1.0,
              left: 0.0,
              right: 0.0,
              child: Visibility(
                visible: this.showScrollUpButton,
                child: Container(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        onPressed: () {
                          this._scrollController.animateTo(
                              this._scrollController.offset - 200,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Icon(Icons.arrow_upward))),
                replacement: SizedBox.shrink(),
              )),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Visibility(
                visible: this.showScrollDownButton,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        onPressed: () {
                          this._scrollController.animateTo(
                              this._scrollController.offset + 200,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Icon(Icons.arrow_downward))),
                replacement: SizedBox.shrink(),
              ))
        ],
      );
    });
  }
}
