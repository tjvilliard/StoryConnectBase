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
    return Column(children: [
      SizedBox(
        height: 150,
        width: 100,
        child: Icon(Icons.book, size: 100),
      ),
      bookTitle()
    ]);
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

  Widget bookTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.book.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (widget.book.authorName != null)
          Text(
            widget.book.authorName ?? "No name",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white),
          ),
      ],
    );
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
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentGeometry.lerp(Alignment.center, Alignment.topCenter, 0.75)!,
                children: [
                  // Image or Placeholder
                  if (url != null && url!.isNotEmpty)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ImageLoader(
                          url: url!,
                          fit: BoxFit.cover,
                          constraints: BoxConstraints.expand(),
                        )),
                  if (url == null || url!.isEmpty) _imagePlaceHolder(),
                  if (url != null && url!.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: [Color.fromARGB(181, 0, 0, 0), Colors.black54],
                            ),
                          ),
                          child: bookTitle()),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
