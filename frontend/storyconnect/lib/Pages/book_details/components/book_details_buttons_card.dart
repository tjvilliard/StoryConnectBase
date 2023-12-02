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
  bool inLibrary = false;

  @override
  void initState() {
    ReadingHubBloc bloc = context.read<ReadingHubBloc>();
    bloc.add(const FetchLibraryBooksEvent());

    inLibrary = bloc.state.libraryBookMap.keys
        .where((element) => element.book == widget.bookId)
        .isNotEmpty;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: BookDetailsView.secondaryCardElevation,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
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
                    final uri = PageUrls.readBook(widget.bookId!);
                    Beamer.of(context)
                        .beamToNamed(uri, data: {"book": widget.bookId});
                  },
                )),
                Expanded(child: BlocBuilder<ReadingHubBloc, ReadingHubStruct>(
                    builder: (context, state) {
                  Widget toReturn;
                  OutlinedBorder? libButtonBorder =
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                              topLeft: Radius.zero,
                              bottomLeft: Radius.zero));

                  if (state.loadingStruct.isLoading) {
                    toReturn = ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: libButtonBorder),
                        onPressed: () {},
                        child:
                            LoadingWidget(loadingStruct: state.loadingStruct));
                  } else {
                    toReturn = ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: libButtonBorder),
                        onPressed: () {
                          ReadingHubBloc bloc = context.read<ReadingHubBloc>();
                          if (inLibrary) {
                            bloc.add(
                                RemoveLibraryBookEvent(bookId: widget.bookId!));
                          } else {
                            bloc.add(
                                AddLibraryBookEvent(bookId: widget.bookId!));
                          }

                          inLibrary = !inLibrary;
                          setState(() {});
                        },
                        child: inLibrary
                            ? const Text("Add To Library")
                            : const Text("Remove From Library"));
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: toReturn,
                  );
                })),
              ])),
    );
  }
}
