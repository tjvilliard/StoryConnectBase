import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/components/book_items/book_cover.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';

class BigBook extends StatelessBookItem {
  final Book book;

  BigBook({required this.book});

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  Widget _topRightHandDetail({required Widget textItem}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 0.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 190.0, maxHeight: 190.0),
              child: textItem,
            )));
  }

  Widget _rightHandDetail({required Widget textItem}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 190.0, maxHeight: 190.0),
              child: textItem,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 270,
        width: 400.0,
        child: Card(
            elevation: 3,
            child: Clickable(
                onPressed: () {
                  final uri = PageUrls.readBook(book.id);
                  Beamer.of(context).beamToNamed(uri, data: {"book": book});
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.book,
                          size: 175,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              this._topRightHandDetail(
                                  textItem: Text(
                                this.book.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              )),
                              this._rightHandDetail(
                                  textItem: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                            child: Icon(Icons.person_outline,
                                                size: 16)),
                                        TextSpan(
                                            text: "Author Fillin...",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall)
                                      ]))),
                              this._rightHandDetail(
                                  textItem: Text(
                                      book.synopsis == null
                                          ? ""
                                          : book.synopsis!,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12)))
                            ]),
                      ],
                    ),
                  ],
                ))));
  }
}
