import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/state/reading_hub_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/library_book_item.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/library_book_cover.dart';

class BookGridWidget extends StatelessWidget {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;
  final int category;

  final bool descript = false;

  const BookGridWidget({
    super.key,
    required this.books,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingHubBloc, ReadingHubStruct>(
      builder: (BuildContext context, state) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse
                    }),
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: books
                          .map((book) => LibraryBookItem(
                              bookId: book.id,
                              category: category,
                              child: LibraryBookCoverWidget(book: book)))
                          .toList(),
                    ))));
      },
    );
  }
}
