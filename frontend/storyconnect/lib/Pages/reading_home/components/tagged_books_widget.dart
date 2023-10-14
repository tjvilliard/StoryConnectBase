import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_home/components/book_widget.dart';
import 'package:storyconnect/Services/url_service.dart';
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
      lists.add(
          new TaggedBookListWidget(primaryTag: entry.key, books: entry.value));
    }
    return lists;
  }

  Color selectColor(int index) {
    int mod = index % 3;

    switch (mod) {
      case 0:
        return Colors.grey.withOpacity(.1);
      case 1:
        return Colors.blue.withOpacity(.1);
      case 2:
        return Colors.green.withOpacity(.1);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bookSets = this._buildLists();
    int numSets = bookSets.length;

    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: numSets,
          itemBuilder: (BuildContext content, int i) {
            return Container(color: this.selectColor(i), child: bookSets[i]);
          },
        ));
  }
}

class TaggedBookListWidget extends StatelessWidget {
  final String primaryTag;
  final List<Book> books;

  TaggedBookListWidget({required this.primaryTag, required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          Header(title: primaryTag),
          SizedBox(
              height: 220,
              child: ListView(
                  itemExtent: 400.0,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: this
                      .books
                      .map((book) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: Container(
                              width: 400,
                              height: 200,
                              child: Clickable(
                                  onPressed: () {
                                    final url = PageUrls.readBook(book.id);
                                    Beamer.of(context)
                                        .beamToNamed(url, data: {"book": book});
                                  },
                                  child: BookCardWidget(
                                    title: book.title,
                                    author: "Author Placeholder",
                                  )))))
                      .toList()))
        ]));
  }
}
