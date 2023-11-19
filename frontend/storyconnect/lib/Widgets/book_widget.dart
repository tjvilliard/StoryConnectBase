import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
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
      if (mounted) {
        setState(() {
          url = "";
        });
      }

      return;
    }
    Reference ref = FirebaseStorage.instance.ref().child(relativePath);
    final result = await ref.getDownloadURL();
    if (mounted) {
      setState(() {
        url = result;
      });
    }
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
              if (url != null && url!.isNotEmpty)
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageLoader(
                      url: url!,
                      fit: BoxFit.cover,
                      constraints: BoxConstraints(maxWidth: 100, maxHeight: 160),
                    )),
              if (url == null || url!.isEmpty) _imagePlaceHolder(),
              Flexible(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.book.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ))),
              if (widget.book.authorName != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(widget.book.authorName ?? "No name", style: Theme.of(context).textTheme.labelSmall)],
                )
            ],
          ),
        ));
  }
}
