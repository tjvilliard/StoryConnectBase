import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';

class BookWidget extends StatefulWidget {
  final Book book;

  BookWidget({required this.book});

  @override
  State<StatefulWidget> createState() {
    return BookWidgetState();
  }
}

class BookWidgetState extends State<BookWidget> {
  String? url = null;

  @override
  void initState() {
    get_image(widget.book.cover);
    super.initState();
  }

  // build a rectangular placeholder for the book cover
  Widget _imagePlaceHolder() {
    return SizedBox(
      height: 150,
      width: 100,
      child: Icon(Icons.book, size: 100),
    );
  }

  Future<void> get_image(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      setState(() {
        url = "";
      });
      return;
    }
    Reference ref = FirebaseStorage.instance.ref().child(relativePath);

    final result = await ref.getDownloadURL();

    setState(() {
      url = result;
    });
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
          if (url != null && url!.isNotEmpty) Image.network(url!),
          if (url == null || url!.isEmpty) _imagePlaceHolder(),
          Flexible(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.book.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ))),
          if (widget.book.author != null)
            Text(widget.book.author!,
                style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
