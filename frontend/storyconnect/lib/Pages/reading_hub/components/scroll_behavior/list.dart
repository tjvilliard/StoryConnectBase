import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/horizontal_scroll_behavior.dart';

abstract class BookList extends StatefulWidget {
  final HorizontalScrollBehavior behaviorState;

  BookList({required this.behaviorState});
}

abstract class BookListState extends State<BookList> {
  final HorizontalScrollBehavior behaviorState;

  BookListState({required this.behaviorState});
}
