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
  List<Widget> _buildSlivers() {
    List<Widget> slivers = [];

    for (MapEntry<String, List<Book>> entry in this.taggedBooks.entries) {
      slivers.add(new TaggedBookListWidget(tag: entry.key, books: entry.value));
    }
    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: this._buildSlivers(),
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Header(title: tag),
            SliverList.list(
              children: books
                  .map((book) => Container(
                      width: 150,
                      height: 200,
                      child: Clickable(
                          onPressed: () {
                            //final url = PageUrls.book(book.id);
                            //Beamer.of(context)
                            //    .beamToNamed(url, data: {"book": book});
                          },
                          child: BookWidget(title: book.title, coverCDN: ""))))
                  .toList(),
            )
          ],
        ));
  }
}
