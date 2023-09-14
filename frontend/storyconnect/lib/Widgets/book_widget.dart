import 'package:flutter/material.dart';

class BookWidget extends StatelessWidget {
  final String title;
  final String? author; // if we're the author, we don't need to show this
  final String coverCDN;

  BookWidget({required this.title, this.author, required this.coverCDN});

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
          _imagePlaceHolder(),
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          if (author != null)
            Text(author!, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
