import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsButtonsCard extends StatelessWidget {
  const BookDetailsButtonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 325,
        child: Card(
            elevation: BookDetailsView.secondaryCardElevation,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
                    builder: (context, bookState) {
                  return BlocBuilder<LibraryBloc, LibraryState>(
                      builder: (context, state) {
                    Widget toReturn;

                    if (state.libraryLoadingStruct.isLoading ||
                        bookState.bookDetailsLoadingStruct.isLoading) {
                      toReturn = Align(
                          alignment: Alignment.center,
                          child: LoadingWidget(
                              loadingStruct: state.libraryLoadingStruct));
                    } else if (bookState.book == null) {
                      toReturn = const SizedBox.shrink();
                    } else {
                      toReturn = Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(24),
                                                    bottomLeft:
                                                        Radius.circular(24),
                                                    topRight: Radius.zero,
                                                    bottomRight: Radius.zero))),
                                        child: const Text("Start Reading!"),
                                        onPressed: () {
                                          final uri = PageUrls.readBook(
                                              bookState.book!.id);
                                          Beamer.of(context).beamToNamed(uri,
                                              data: {
                                                "book": bookState.book!.id
                                              });
                                        }))),
                            Expanded(
                                child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(24),
                                                    bottomRight:
                                                        Radius.circular(24),
                                                    topLeft: Radius.zero,
                                                    bottomLeft: Radius.zero))),
                                        onPressed: () {
                                          LibraryBloc bloc =
                                              context.read<LibraryBloc>();
                                          if (state.containsBook(
                                              bookState.book!.id)) {
                                            bloc.add(RemoveBookFromLibraryEvent(
                                                bookId: bookState.book!.id));
                                          } else {
                                            bloc.add(AddBookToLibraryEvent(
                                                bookId: bookState.book!.id));
                                          }
                                        },
                                        child: state.containsBook(
                                                bookState.book!.id)
                                            ? const Text("Remove From Library")
                                            : const Text("Add To Library")))),
                          ]);
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: toReturn,
                    );
                  });
                }))));
  }
}
