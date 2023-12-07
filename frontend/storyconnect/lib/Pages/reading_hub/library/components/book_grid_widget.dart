import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/library_cover/library_book_item.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/library_cover/library_book_cover.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookGridWidget extends StatelessWidget {
  /// The set of books we are displaying in this panel item.
  final int category;

  final bool descript = false;

  const BookGridWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (BuildContext context, state) {
        Widget toReturn;

        if (state.libraryLoadingStruct.isLoading) {
          toReturn = Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 184.0),
                  child: LoadingWidget(
                      loadingStruct: state.libraryLoadingStruct)));
        } else {
          List<Book> books;
          switch (category) {
            case 1:
              books = state.currentlyReading;
            case 2:
              books = state.completed;
            case 3:
              books = state.unread;
            default:
              books = state.currentlyReading;
          }

          toReturn = Align(
              alignment: Alignment.topCenter,
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse
                      }),
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 48.0,
                      ),
                      child: Wrap(
                        spacing: 32.0,
                        runSpacing: 32.0,
                        alignment: WrapAlignment.start,
                        children: books
                            .map((book) => LibraryBookItem(
                                bookId: book.id,
                                category: category,
                                child: LibraryBookCoverWidget(book: book)))
                            .toList(),
                      ))));
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: toReturn,
        );
      },
    );
  }
}
