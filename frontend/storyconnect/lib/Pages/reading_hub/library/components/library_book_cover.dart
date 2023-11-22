import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';

abstract class StatelessBookItem extends StatelessWidget {
  const StatelessBookItem({super.key});
}

///
class LibraryBookCoverWidget extends StatelessBookItem {
  final Book book;

  const LibraryBookCoverWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 270,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.book,
                size: 175,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 34.0, vertical: 2.0),
                child: Text(
                  book.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 34.0, vertical: 2.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                          child: Icon(Icons.person_outline, size: 16)),
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