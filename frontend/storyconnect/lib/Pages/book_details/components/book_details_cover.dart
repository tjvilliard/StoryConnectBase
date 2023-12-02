import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Widgets/image_loader.dart';

class BookDetailsCover extends StatefulWidget {
  final Book? book;

  const BookDetailsCover({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => BookDetailsCoverState();
}

class BookDetailsCoverState extends State<BookDetailsCover> {
  String? url;

  @override
  void initState() {
    getImage(widget.book!.cover);
    super.initState();
  }

  Widget _imagePlaceHolder() {
    return const Column(children: [
      SizedBox(
        height: 350 * 1.6180,
        width: 350,
        child: Icon(Icons.book, size: 200),
      )
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (url == null || url!.isEmpty) _imagePlaceHolder(),
      if (url != null && url!.isNotEmpty)
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ImageLoader(
              url: url!,
              fit: BoxFit.cover,
              constraints: const BoxConstraints(
                maxHeight: 350 * 1.6180,
                minHeight: 350 * 1.6180,
                maxWidth: 350,
                minWidth: 350,
              ),
            )),
    ]);
  }
}
