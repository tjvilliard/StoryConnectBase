import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/big_book.dart';
import 'package:storyconnect/Pages/reading_hub/components/sample_books.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/components/list.dart';

class SampleBookList extends BookList {
  SampleBookList();

  @override
  _sampleBookListState createState() => _sampleBookListState();
}

class _sampleBookListState extends BookListState {
  _sampleBookListState();

  @override
  Widget build(BuildContext context) {
    List<Book> books = sampleBooksData.sample();

    return BlocBuilder<HorizontalScrollBehaviorBloc, HorizontalScrollState>(
        builder: (BuildContext context, HorizontalScrollState state) {
      return ListView.builder(
          itemCount: books.length,
          controller: state.scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            return BigBook(book: books[index]);
          });
    });
  }
}
