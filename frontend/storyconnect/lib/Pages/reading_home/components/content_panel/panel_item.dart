import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_home/components/content_panel/book_item.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

/// A set of panel items. Could be a list of tagged Books.
abstract class PanelItem extends StatelessWidget {}

class BlankPanel extends PanelItem {
  @override
  Widget build(BuildContext context) {
    return Container(height: 200);
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

///
class BookTabSet extends PanelItem {
  ///
  final Map<String, List<Book>> taggedBooks;

  final bool descript;

  BookTabSet({required this.taggedBooks, bool this.descript = false});

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = <Widget>[];

    List<Widget> bookSets = <Widget>[];

    for (MapEntry<String, List<Book>> bookEntry in this.taggedBooks.entries) {
      tabs.add(Text(bookEntry.key));
      bookSets.add(BookList(books: bookEntry.value, descript: this.descript));
    }

    return SizedBox(
        width: 800,
        height: 600,
        child: DefaultTabController(
            length: taggedBooks.length,
            child: Column(children: [
              TabBar(tabs: tabs),
              TabBarView(children: bookSets),
            ])));
  }
}

/// A list of Books to be displayed as a panel item.
class BookList extends PanelItem {
  /// The set of books we are displaying in this panel item.
  final List<Book> books;

  final bool descript;

  BookList({
    required List<Book> this.books,
    required bool this.descript,
  });

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
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 270,
                        child: ListView(
                            itemExtent: descript ? 400.0 : (270 / 1.618) + 25,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: this
                                .books
                                .map((book) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: descript ? 400.0 : 270.0 / 1.618,
                                        child: Clickable(
                                            onPressed: () {},
                                            child: this.descript
                                                ? DescriptBookItem(book: book)
                                                : CoverBookItem(book: book)))))
                                .toList()))))));
  }
}
