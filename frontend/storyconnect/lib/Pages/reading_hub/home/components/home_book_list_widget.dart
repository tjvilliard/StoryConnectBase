import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/horizontal_scroll_behavior.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/list.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/scroll_buttons.dart';

class BookListWidget extends StatefulWidget {
  final HorizontalScrollBehavior behaviorState;
  final BookList bookList;

  BookListWidget({required this.behaviorState, required this.bookList});

  @override
  _bookListWidgetState createState() => _bookListWidgetState(
      behaviorState: this.behaviorState, bookList: this.bookList);
}

class _bookListWidgetState extends State<BookListWidget> {
  final HorizontalScrollBehavior behaviorState;
  final BookList bookList;

  _bookListWidgetState({required this.behaviorState, required this.bookList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
      child: Stack(
        children: [
          this.bookList,
          NavigateLeftButton(behaviorState: this.behaviorState),
          NavigateRightButton(behaviorState: this.behaviorState),
        ],
      ),
    );
  }
}
