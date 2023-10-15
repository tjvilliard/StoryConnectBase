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

/// A list of Books to be displayed as a panel item.
class BookList extends PanelItem {
  /// The set of books we are displaying in this panel item.
  late final List<Book> _books;

  BookList({required List<Book> books}) {
    this._books = books;
  }

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
                            itemExtent: 400.0,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: this
                                ._books
                                .map((book) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: 400,
                                        child: Clickable(
                                            onPressed: () {},
                                            child:
                                                DescriptBookItem(book: book)))))
                                .toList()))))));
  }
}
