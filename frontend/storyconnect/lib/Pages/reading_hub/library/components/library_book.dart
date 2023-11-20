import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
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
  _libraryBookState createState() => _libraryBookState(
        child: this.child,
        bookId: this.bookId,
      );
}

class _detailsButton extends StatelessWidget {
  final int bookId;

  _detailsButton({required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? _buttonStyle = ButtonStyle(
        textStyle:
            MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return BlocBuilder<LibraryBloc, LibraryStruct>(
      builder: (BuildContext context, LibraryStruct state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton(
            style: _buttonStyle,
            onPressed: () {},
            child: Text("Details"),
          ),
        );
      },
    );
  }
}

class _removeBookButton extends StatelessWidget {
  final int bookId;

  _removeBookButton({required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? _buttonStyle = ButtonStyle(
        textStyle:
            MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return BlocBuilder<LibraryBloc, LibraryStruct>(
      builder: (BuildContext context, LibraryStruct state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton(
              style: _buttonStyle,
              onPressed: () {
                context
                    .read<LibraryBloc>()
                    .add(RemoveBookEvent(bookId: this.bookId));
              },
              child: Text("Remove")),
        );
      },
    );
  }
}

///
class _libraryBookState extends State<LibraryBookItem> {
  bool showButtons = false;
  final int bookId;
  final Widget child;
  _libraryBookState({
    required this.bookId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? _buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          Theme.of(context).textTheme.bodySmall,
        ),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            side: BorderSide(width: 4.0),
            borderRadius: BorderRadius.circular(10))));

    return Card(
        elevation: 4,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: MouseRegion(
                onEnter: (_) => setState(() {
                      this.showButtons = true;
                    }),
                onExit: (_) => setState(() {
                      this.showButtons = false;
                    }),
                cursor: MouseCursor.defer,
                child: Stack(
                  children: [
                    child,
                    this.showButtons
                        ? Positioned.fill(
                            child: Material(
                              color: Colors.black38.withOpacity(.25),
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 32.0, horizontal: 32.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: OutlinedButton(
                                              style: _buttonStyle,
                                              onPressed: () {
                                                final uri = PageUrls.readBook(
                                                    this.bookId);
                                                Beamer.of(context)
                                                    .beamToNamed(uri, data: {
                                                  "book": this.bookId
                                                });
                                              },
                                              child: Text("Start Reading")),
                                        ),
                                        _detailsButton(bookId: bookId),
                                        _removeBookButton(bookId: bookId)
                                      ])),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ))));
  }
}
