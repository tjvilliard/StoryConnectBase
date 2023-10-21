import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';

class BookWidget extends StatelessWidget {
  final Book book;

  BookWidget({required this.book});

  // build a rectangular placeholder for the book cover
  Widget _imagePlaceHolder() {
    return SizedBox(
      height: 150,
      width: 100,
      child: Icon(Icons.book, size: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Image.network(coverCDN),
          if (book.cover != null && book.cover!.isNotEmpty)
            Image.network(book.cover!),
          if (book.cover == null || book.cover?.isEmpty == true)
            _imagePlaceHolder(),
          Flexible(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    book.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ))),
          if (book.author != null)
            Text(book.author!, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
