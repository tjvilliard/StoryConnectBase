import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/library_book.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/book_cover.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';

class BookGridWidget extends StatelessWidget {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;

  final bool descript = false;

  BookGridWidget({required List<Book> this.books});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryStruct>(
      builder: (BuildContext context, state) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse
                    }),
                child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: this
                          .books
                          .map((book) => LibraryBookItem(
                              bookId: book.id,
                              child: BookCoverWidget(book: book)))
                          .toList(),
                    ))));
      },
    );
  }
}
