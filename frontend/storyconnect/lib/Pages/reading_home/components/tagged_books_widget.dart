import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/book_widget.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/header.dart';

/// A scrollable set of Multiple lists of books, organized by tag.
class TaggedBooksListWidget extends StatelessWidget {
  /// The map of book tag to book list.
  final Map<String, List<Book>> taggedBooks;

  TaggedBooksListWidget({required this.taggedBooks});

  /// Builds a list of tagged book widgets.
  List<Widget> _buildLists() {
    List<Widget> lists = [];

    for (MapEntry<String, List<Book>> entry in this.taggedBooks.entries) {
      lists.add(new TaggedBookListWidget(tag: entry.key, books: entry.value));
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: this._buildLists())),
    );
  }
}

class TaggedBookListWidget extends StatelessWidget {
  final String tag;
  final List<Book> books;

  TaggedBookListWidget({required this.tag, required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          Header(title: tag),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: this
                  .books
                  .map((book) => Container(
                      width: 150,
                      height: 200,
                      child: Clickable(
                          onPressed: () {},
                          child: BookWidget(title: book.title, coverCDN: ""))))
                  .toList(),
            ),
          )
        ]));
  }
}
