import 'dart:ui';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/detailed_book_item.dart';
import 'package:storyconnect/Pages/reading_hub/components/content_panel/book_item.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

/// A set of panel items. Could be a list of tagged Books.
abstract class PanelItem extends StatelessWidget {}

class BlankPanel extends PanelItem {
  final double height;
  BlankPanel({this.height = 50.0});
  @override
  Widget build(BuildContext context) {
    return Container(height: this.height);
  }
}

class DividerPanel extends PanelItem {
  /// The color of this divider.
  final Color color;

  /// The thickness of the line drawn by the divider.
  final double? thickness;

  DividerPanel({required this.color, this.thickness = null});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 850,
        child: Divider(
          color: this.color,
          thickness: this.thickness,
          height: 0.0,
          indent: 0,
          endIndent: 0,
        ));
  }
}

/// The Header for a set of panel items.
class PanelHeader extends PanelItem {
  late final String _text;
  PanelHeader(String text) {
    this._text = text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 800,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0),
          child: Text(this._text, style: TextStyle(fontSize: 28)),
        ));
  }
}

class PanelSubtitle extends PanelItem {
  late final String _text;
  PanelSubtitle(String text) {
    this._text = text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 800,
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: Text(this._text, style: TextStyle(fontSize: 20)),
        ));
  }
}

/// A loading widget item inside a panel.
class LoadingItem extends PanelItem {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: LoadingWidget(loadingStruct: LoadingStruct(isLoading: true)));
  }
}

class BookGrid extends PanelItem {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;

  final bool descript = false;

  BookGrid({required List<Book> this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: SizedBox(
            width: 800,
            child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse
                    }),
                child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: this
                          .books
                          .map((book) => Container(
                              height: 270,
                              width: (270.0 / 1.618) + 25,
                              child: Card(
                                  elevation: 4,
                                  child: Clickable(
                                      onPressed: () {
                                        final uri = PageUrls.readBook(book.id);
                                        Beamer.of(context).beamToNamed(uri,
                                            data: {"book": book});
                                      },
                                      child: CoverBookItem(book: book)))))
                          .toList(),
                    )))));
  }
}

/// A list of Books to be displayed as a panel item.
class BookListWidget extends StatefulWidget {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;

  final bool descript;

  BookListWidget({
    required List<Book> this.books,
    required bool this.descript,
  });

  @override
  _BookListWidgetState createState() => _BookListWidgetState(
        books: books,
        descript: descript,
      );
}

class _BookListWidgetState extends State<BookListWidget> {
  final List<Book> books;
  final bool descript;
  final ScrollController _scrollController = ScrollController();
  late bool showScrollLeftButton;
  late bool showScrollRightButton;

  _BookListWidgetState({
    required List<Book> this.books,
    required bool this.descript,
  });

  @override
  void initState() {
    this.showScrollLeftButton = false;

    if (this.descript) {
      if (this.books.length < 3) {
        this.showScrollRightButton = false;
      } else {
        this.showScrollRightButton = true;
      }
    } else {
      if (this.books.length < 5) {
        this.showScrollRightButton = false;
      } else {
        this.showScrollRightButton = true;
      }
    }

    // Check out
    // https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
    // for more
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          this.showScrollLeftButton = false;
        } else {
          this.showScrollRightButton = false;
        }
      } else {
        this.showScrollRightButton = true;
        this.showScrollLeftButton = true;
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: SizedBox(
            width: 800,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse
                        }),
                    child: SingleChildScrollView(
                      controller: this._scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: this
                              .books
                              .map((book) => Container(
                                  height: 270,
                                  width:
                                      descript ? 400.0 : (270.0 / 1.618) + 25,
                                  child: Card(
                                      elevation: 3,
                                      child: Clickable(
                                          onPressed: () {
                                            final uri =
                                                PageUrls.readBook(book.id);
                                            Beamer.of(context).beamToNamed(uri,
                                                data: {"book": book});
                                          },
                                          child: this.descript
                                              ? newDescriptBookItem(book: book)
                                              : CoverBookItem(book: book)))))
                              .toList()),
                    )),
                Positioned(
                    left: 1.0,
                    child: Visibility(
                        visible: this.showScrollLeftButton,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()),
                                onPressed: () {
                                  this._scrollController.animateTo(
                                      this._scrollController.offset - 400,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                },
                                child: Icon(FontAwesomeIcons.arrowLeft))),
                        replacement: SizedBox.shrink())),
                Positioned(
                    right: 1.0,
                    child: Visibility(
                        visible: this.showScrollRightButton,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder()),
                                onLongPress: () {},
                                onPressed: () {
                                  this._scrollController.animateTo(
                                      this._scrollController.offset + 400,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                },
                                child: Icon(FontAwesomeIcons.arrowRight))),
                        replacement: SizedBox.shrink()))
              ],
            )));
  }
}
