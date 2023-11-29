import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/book_widget.dart';
import 'package:storyconnect/Widgets/clickable.dart';

class BookListWidget extends StatelessWidget {
  final List<Book> books;

  const BookListWidget({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: books
                  .map((book) => SizedBox(
                      key: ValueKey(book.id),
                      width: 150,
                      height: 200,
                      child: Clickable(
                          onPressed: () {
                            final url = PageUrls.book(book.id);
                            Beamer.of(context).beamToNamed(url, data: {"book": book});
                          },
                          child: BookWidget(
                            book: book,
                          ))))
                  .toList(),
            )));
  }
}
