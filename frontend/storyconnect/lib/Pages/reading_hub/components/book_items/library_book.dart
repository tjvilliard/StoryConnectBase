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
  LibraryBookState createState() => LibraryBookState();
}

///
class LibraryBookState extends State<LibraryBookItem> {
  bool showButtons = false;

  int get bookId => widget.bookId;
  Widget get child => widget.child;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor: MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(side: const BorderSide(width: 1.0), borderRadius: BorderRadius.circular(10))));

    return SizedBox(
        height: 270,
        width: (270.0 / 1.618) + 25,
        child: Card(
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
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      child,
                      showButtons
                          ? Positioned.fill(
                              child: Material(
                                color: Theme.of(context).hoverColor,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: OutlinedButton(
                                                style: buttonStyle,
                                                onPressed: () {
                                                  final uri = PageUrls.readBook(bookId);
                                                  Beamer.of(context).beamToNamed(uri, data: {"book": bookId});
                                                },
                                                child: const Text("Start Reading")),
                                          ),
                                          _RemoveBookButton(bookId: bookId)
                                        ])),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ))),
        ));
  }
}

class _RemoveBookButton extends StatelessWidget {
  final int bookId;

  const _RemoveBookButton({required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        overlayColor: MaterialStatePropertyAll(Theme.of(context).hoverColor),
        backgroundColor: MaterialStatePropertyAll(Theme.of(context).canvasColor),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(side: const BorderSide(width: 1.0), borderRadius: BorderRadius.circular(10))));

    return BlocBuilder<LibraryBloc, LibraryStruct>(
      builder: (BuildContext context, LibraryStruct state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton(
              style: buttonStyle,
              onPressed: () {
                context.read<LibraryBloc>().add(RemoveBookEvent(bookId: bookId));
              },
              child: const Text("Remove from Library")),
        );
      },
    );
  }
}
