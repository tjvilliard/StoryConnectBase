import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/list.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/scroll_buttons.dart';

class BookListWidget extends StatefulWidget {
  final BookList bookList;

  const BookListWidget({super.key, required this.bookList});

  @override
  BookListWidgetState createState() => BookListWidgetState(bookList: bookList);
}

class BookListWidgetState extends State<BookListWidget> {
  final BookList bookList;

  BookListWidgetState({required this.bookList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HorizontalScrollBehaviorBloc>(
        create: (context) => HorizontalScrollBehaviorBloc(
            animationDistance: 400, animationDurationMsec: 350),
        child: Container(
          height: 220,
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: Stack(
            children: [
              bookList,
              const NavigateLeftButton(),
              const NavigateRightButton(),
            ],
          ),
        ));
  }
}
