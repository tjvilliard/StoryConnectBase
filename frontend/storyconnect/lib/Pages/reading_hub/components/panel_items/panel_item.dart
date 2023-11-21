import 'dart:ui';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/library_book.dart';
import 'package:storyconnect/Pages/reading_hub/components/detailed_book_item.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/book_cover.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

/// A set of panel items. Could be a list of tagged Books.
abstract class PanelItem extends StatelessWidget {
  const PanelItem({super.key});
}

class BlankPanel extends PanelItem {
  final double height;
  const BlankPanel({super.key, this.height = 50.0});
  @override
  Widget build(BuildContext context) {
    return Container(height: height);
  }
}

class DividerPanel extends PanelItem {
  /// The color of this divider.
  final Color color;

  /// The thickness of the line drawn by the divider.
  final double? thickness;

  const DividerPanel({super.key, required this.color, this.thickness});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 850,
        child: Divider(
          color: color,
          thickness: thickness,
          height: 0.0,
          indent: 0,
          endIndent: 0,
        ));
  }
}

/// The Header for a set of panel items.
class PanelHeader extends PanelItem {
  late final String _text;
  PanelHeader(String text, {super.key}) {
    _text = text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0),
          child: Text(_text, style: const TextStyle(fontSize: 28)),
        ));
  }
}

class PanelSubtitle extends PanelItem {
  late final String _text;
  PanelSubtitle(String text, {super.key}) {
    _text = text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: Text(_text, style: const TextStyle(fontSize: 20)),
        ));
  }
}

/// A loading widget item inside a panel.
class LoadingItem extends PanelItem {
  const LoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: LoadingWidget(loadingStruct: LoadingStruct(isLoading: true)));
  }
}

class BookGrid extends PanelItem {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;

  final bool descript = false;

  const BookGrid({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryStruct>(
      builder: (BuildContext context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: SizedBox(
                width: 800,
                child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
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
                              .map((book) => LibraryBookItem(bookId: book.id, child: BookCoverWidget(book: book)))
                              .toList(),
                        )))));
      },
    );
  }
}

/// A list of Books to be displayed as a panel item.
class BookListWidget extends StatefulWidget {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;

  final bool descript;

  const BookListWidget({
    super.key,
    required this.books,
    required this.descript,
  });

  @override
  BookListWidgetState createState() => BookListWidgetState();
}

class BookListWidgetState extends State<BookListWidget> {
  List<Book> get books => widget.books;
  bool get descript => widget.descript;

  final ScrollController _scrollController = ScrollController();
  late bool showScrollLeftButton;
  late bool showScrollRightButton;

  @override
  void initState() {
    showScrollLeftButton = false;

    if (descript) {
      if (books.length < 3) {
        showScrollRightButton = false;
      } else {
        showScrollRightButton = true;
      }
    } else {
      if (books.length < 5) {
        showScrollRightButton = false;
      } else {
        showScrollRightButton = true;
      }
    }

    // Check out
    // https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
    // for more
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          showScrollLeftButton = false;
        } else {
          showScrollRightButton = false;
        }
      } else {
        showScrollRightButton = true;
        showScrollLeftButton = true;
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: SizedBox(
            width: 800,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: books
                              .map((book) => SizedBox(
                                  height: 270,
                                  width: descript ? 400.0 : (270.0 / 1.618) + 25,
                                  child: Card(
                                      elevation: 3,
                                      child: Clickable(
                                          onPressed: () {
                                            final uri = PageUrls.readBook(book.id);
                                            Beamer.of(context).beamToNamed(uri, data: {"book": book});
                                          },
                                          child: descript
                                              ? NewDescriptBookItem(book: book)
                                              : BookCoverWidget(book: book)))))
                              .toList()),
                    )),
                Positioned(
                    left: 1.0,
                    child: Visibility(
                        visible: showScrollLeftButton,
                        replacement: const SizedBox.shrink(),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                                onPressed: () {
                                  _scrollController.animateTo(_scrollController.offset - 400,
                                      duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
                                },
                                child: const Icon(Icons.arrow_left))))),
                Positioned(
                    right: 1.0,
                    child: Visibility(
                        visible: showScrollRightButton,
                        replacement: const SizedBox.shrink(),
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                                onLongPress: () {},
                                onPressed: () {
                                  _scrollController.animateTo(_scrollController.offset + 400,
                                      duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
                                },
                                child: const Icon(Icons.arrow_right)))))
              ],
            )));
  }
}
