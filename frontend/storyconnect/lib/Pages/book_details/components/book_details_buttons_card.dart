import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Pages/reading_hub/state/reading_hub_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsButtonsCard extends StatefulWidget {
  final int? bookId;

  const BookDetailsButtonsCard({super.key, required this.bookId});

  @override
  BookDetailsButtonsCardState createState() => BookDetailsButtonsCardState();
}

class BookDetailsButtonsCardState extends State<BookDetailsButtonsCard> {
  // If True, book is in library and can be removed
  // If false, book is not in library and can be added.
  bool inLibrary = false;

  @override
  void initState() {
    ReadingHubBloc bloc = context.read<ReadingHubBloc>();
    bloc.add(const FetchLibraryBooksEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: Card(
          elevation: BookDetailsView.secondaryCardElevation,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<ReadingHubBloc, ReadingHubStruct>(
                  builder: (context, readingHubState) {
                Widget toReturn;

                if (readingHubState.loadingStruct.isLoading) {
                  toReturn = Align(
                      alignment: Alignment.center,
                      child: LoadingWidget(
                          loadingStruct: readingHubState.loadingStruct));
                } else {
                  inLibrary = readingHubState.libraryBookMap.values
                      .where((element) => element.id == widget.bookId)
                      .isNotEmpty;
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
                                                topLeft: Radius.circular(24),
                                                bottomLeft: Radius.circular(24),
                                                topRight: Radius.zero,
                                                bottomRight: Radius.zero))),
                                    child: const Text("Start Reading!"),
                                    onPressed: () {
                                      final uri =
                                          PageUrls.readBook(widget.bookId!);
                                      Beamer.of(context).beamToNamed(uri,
                                          data: {"book": widget.bookId});
                                    }))),
                        Expanded(
                            child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(24),
                                          bottomRight: Radius.circular(24),
                                          topLeft: Radius.zero,
                                          bottomLeft: Radius.zero))),
                              onPressed: () {
                                ReadingHubBloc bloc =
                                    context.read<ReadingHubBloc>();
                                if (inLibrary) {
                                  bloc.add(RemoveLibraryBookEvent(
                                      bookId: widget.bookId!));
                                } else {
                                  bloc.add(AddLibraryBookEvent(
                                      bookId: widget.bookId!));
                                }

                                inLibrary = !inLibrary;
                                setState(() {});
                              },
                              child: inLibrary
                                  ? const Text("Remove From Library")
                                  : const Text("Add To Library")),
                        )),
                      ]);
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: toReturn,
                );
              })),
        ));
  }
}
