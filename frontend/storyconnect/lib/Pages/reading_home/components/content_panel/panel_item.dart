import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_home/components/content_panel/book_item.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

/// A set of panel items. Could be a list of tagged Books.
abstract class PanelItem extends StatelessWidget {}

/// The Header for a set of panel items.
class PanelHeader extends PanelItem {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class PanelSubtitle extends PanelItem {
  late final String _text;
  PanelSubtitle(String text) {
    this._text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(this._text);
  }
}

/// A material horizontal divider to be used between panels.
class PanelDivider extends PanelItem {
  /// The color of this divider.
  final Color color;

  /// The thickness of the line drawn by the divider.
  final double? thickness;

  PanelDivider({required this.color, this.thickness = null});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: this.color,
      thickness: this.thickness,
      height: 0.0,
      indent: 0,
      endIndent: 0,
    );
  }
}

/// A loading widget item inside a panel.
class LoadingItem extends PanelItem {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(32.0),
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
        padding: EdgeInsets.all(32.0),
        child: SizedBox(
            width: 800,
            child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse
                    }),
                child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: SizedBox(
                      height: 200,
                      child: ListView(
                        itemExtent: 400.0,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: this
                            ._books
                            .map((e) => Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Container(
                                    width: 400,
                                    height: 200,
                                    child: Clickable(
                                      onPressed: () {},
                                      child: Card(
                                        color: Colors.black,
                                      ),
                                    ))))
                            .toList(),
                      ),
                    )))));
  }
}
