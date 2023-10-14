import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_home/components/book_widget.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/header.dart';

class BookSetWidget extends StatelessWidget {
  final List<Book> bookSample;

  BookSetWidget({required this.bookSample});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
          child: Card(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: "From your Library"),
          SliverList.list(
            children: this
                .bookSample
                .map((book) => Clickable(
                    onPressed: () {
                      final url = PageUrls.readBook(book.id);
                      Beamer.of(context).beamToNamed(url, data: {"book": book});
                    },
                    child: BookCardWidget(
                      title: book.title,
                      author: book.author!,
                    )))
                .toList(),
          )
        ],
      ))),
    );
  }
}
