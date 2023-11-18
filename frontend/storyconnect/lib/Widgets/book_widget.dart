import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Widgets/display_name_loader.dart';
import 'package:storyconnect/Widgets/image_loader.dart';

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
    return Padding(
        padding: EdgeInsets.all(2),
        child: Card(
          margin: EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (url != null && url!.isNotEmpty) ImageLoader(url: url!),
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
              if (widget.book.owner != null)
                DisplayNameLoaderWidget(id: widget.book.owner!, style: Theme.of(context).textTheme.labelSmall)
            ],
          ),
        ));
  }
}
