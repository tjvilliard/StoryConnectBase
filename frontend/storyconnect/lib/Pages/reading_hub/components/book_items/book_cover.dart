import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';

abstract class StatelessBookItem extends StatelessWidget {}

///
class BookCoverWidget extends StatelessBookItem {
  final Book book;

  BookCoverWidget({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 270,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  Icons.book,
                  size: 175,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 34.0, vertical: 2.0),
                child: Text(
                  this.book.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 34.0, vertical: 2.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.person_outline, size: 16)),
                      TextSpan(
                          text: " Author",
                          style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ]));
  }
}
