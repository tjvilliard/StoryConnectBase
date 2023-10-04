import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/book_widget.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/header.dart';

class LibraryBookSetWidget extends StatelessWidget {
  final List<Book> libarySample;

  LibraryBookSetWidget({required this.libarySample});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Header(title: "From your Library"),
            SliverList.list(
              children: this
                  .libarySample
                  .map((book) => Container(
                      width: 150,
                      height: 200,
                      child: Clickable(
                          onPressed: () {
                            final url = PageUrls.readBook(book.id);
                            Beamer.of(context)
                                .beamToNamed(url, data: {"book": book});
                          },
                          child: BookWidget(title: book.title, coverCDN: ""))))
                  .toList(),
            )
          ],
        ));
  }
}
