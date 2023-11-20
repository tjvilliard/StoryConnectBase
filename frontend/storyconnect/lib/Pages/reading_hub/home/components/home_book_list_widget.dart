import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/list.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/scroll_buttons.dart';

class BookListWidget extends StatefulWidget {
  final BookList bookList;

  BookListWidget({required this.bookList});

  @override
  _bookListWidgetState createState() =>
      _bookListWidgetState(bookList: this.bookList);
}

class _bookListWidgetState extends State<BookListWidget> {
  final BookList bookList;

  _bookListWidgetState({required this.bookList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HorizontalScrollBehaviorBloc>(
        create: (context) => HorizontalScrollBehaviorBloc(
            HorizontalScrollStateImpl(false, true, ScrollController()),
            animationDistance: 400,
            animationDuration_m_sec: 350),
        child: Container(
          height: 220,
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: Stack(
            children: [
              this.bookList,
              NavigateLeftButton(),
              NavigateRightButton(),
            ],
          ),
        ));
  }
}
