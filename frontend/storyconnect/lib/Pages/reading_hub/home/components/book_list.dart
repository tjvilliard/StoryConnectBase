import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_bloc.dart';
import 'package:storyconnect/Widgets/book_widgets/big_book.dart';

class BookList extends StatefulWidget {
  final List<Book> bookList;
  const BookList({super.key, required this.bookList});

  @override
  State<StatefulWidget> createState() => BookListState();
}

class BookListState extends State<BookList> {
  late final List<Book> bookList;

  @override
  void initState() {
    bookList = widget.bookList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HorizontalScrollBehaviorBloc, HorizontalScrollState>(
        builder: (BuildContext context, HorizontalScrollState state) {
      return ListView.builder(
        itemCount: bookList.length,
        controller: state.scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return BigBookWidget(book: bookList[index]);
        },
      );
    });
  }
}
