import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/library_cover/cover_buttons.dart';

///
class LibraryBookItem extends StatefulWidget {
  final int bookId;
  final int category;
  final Widget child;

  const LibraryBookItem({
    super.key,
    required this.bookId,
    required this.category,
    required this.child,
  });

  @override
  LibraryBookState createState() => LibraryBookState();
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
                                        vertical: 32.0, horizontal: 26.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ReadingPageButton(bookId: bookId),
                                          DetailsPageButton(bookId: bookId),
                                          if (widget.category == 1 ||
                                              widget.category == 2)
                                            MarkUnreadButton(bookId: bookId),
                                          if (widget.category == 1)
                                            MarkCompletedButton(bookId: bookId),
                                          RemoveBookButton(bookId: bookId),
                                        ]))))
                        : const SizedBox.shrink(),
                  ],
                ))));
  }
}
