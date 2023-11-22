import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Widgets/image_loader.dart';

class BookWidget extends StatefulWidget {
  final Book book;

  const BookWidget({super.key, required this.book});

  @override
  State<StatefulWidget> createState() {
    return BookWidgetState();
  }
}

class BookWidgetState extends State<BookWidget> {
  String? url;

  @override
  void initState() {
    getImage(widget.book.cover);
    super.initState();
  }

  // build a rectangular placeholder for the book cover
  Widget _imagePlaceHolder() {
    return Column(children: [
      const SizedBox(
        height: 150,
        width: 100,
        child: Icon(Icons.book, size: 100),
      ),
      bookTitle()
    ]);
  }

  Future<void> getImage(String? relativePath) async {
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
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (widget.book.authorName != null)
          Text(
            widget.book.authorName ?? "No name",
            style: Theme.of(context).textTheme.labelSmall,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentGeometry.lerp(
                  Alignment.center, Alignment.topCenter, 0.75)!,
              children: [
                // Image or Placeholder
                if (url != null && url!.isNotEmpty)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageLoader(
                        url: url!,
                        fit: BoxFit.cover,
                        constraints: const BoxConstraints.expand(),
                      )),
                if (url == null || url!.isEmpty) _imagePlaceHolder(),
                if (url != null && url!.isNotEmpty)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(238, 0, 0, 0),
                                  Colors.black54
                                ],
                              ),
                            ),
                            child: bookTitle()),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
