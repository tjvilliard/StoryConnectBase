import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';

///
class LibraryBookItem extends StatefulWidget {
  final int bookId;
  final Widget child;

  const LibraryBookItem({
    super.key,
    required this.bookId,
    required this.child,
  });

  @override
  LibraryBookState createState() => LibraryBookState();
}

class DetailsButton extends StatelessWidget {
  final int bookId;

  const DetailsButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle:
            MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
      builder: (BuildContext context, ReadingHomeStruct state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton(
            style: buttonStyle,
            onPressed: () {},
            child: const Text("Details"),
          ),
        );
      },
    );
  }
}

class RemoveBookButton extends StatelessWidget {
  final int bookId;

  const RemoveBookButton({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle:
            MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return BlocBuilder<ReadingHomeBloc, ReadingHomeStruct>(
      builder: (BuildContext context, ReadingHomeStruct state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton(
              style: buttonStyle,
              onPressed: () {
                context
                    .read<ReadingHomeBloc>()
                    .add(RemoveLibraryBookEvent(bookId: bookId));
              },
              child: const Text("Remove")),
        );
      },
    );
  }
}

///
class LibraryBookState extends State<LibraryBookItem> {
  bool showButtons = false;
  late final int bookId;
  late final Widget child;
  LibraryBookState();

  @override
  void initState() {
    bookId = widget.bookId;
    child = widget.child;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          Theme.of(context).textTheme.bodySmall,
        ),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: const BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return Card(
        elevation: 4,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: MouseRegion(
                onEnter: (_) => setState(() {
                      showButtons = true;
                    }),
                onExit: (_) => setState(() {
                      showButtons = false;
                    }),
                cursor: MouseCursor.defer,
                child: Stack(
                  children: [
                    child,
                    showButtons
                        ? Positioned.fill(
                            child: Material(
                              color: Colors.black38.withOpacity(.25),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0, horizontal: 32.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: OutlinedButton(
                                              style: buttonStyle,
                                              onPressed: () {
                                                final uri =
                                                    PageUrls.readBook(bookId);
                                                Beamer.of(context).beamToNamed(
                                                    uri,
                                                    data: {"book": bookId});
                                              },
                                              child:
                                                  const Text("Start Reading")),
                                        ),
                                        DetailsButton(bookId: bookId),
                                        RemoveBookButton(bookId: bookId)
                                      ])),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ))));
  }
}
