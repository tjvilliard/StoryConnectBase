import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Widgets/image_loader.dart';

///
class LibraryBookCoverWidget extends StatefulWidget {
  final Book book;

  const LibraryBookCoverWidget({super.key, required this.book});

  @override
  LibraryBookCoverWidgetState createState() => LibraryBookCoverWidgetState();
}

class LibraryBookCoverWidgetState extends State<LibraryBookCoverWidget> {
  String? url;

  @override
  void initState() {
    getImage(widget.book.cover);
    super.initState();
  }

  Widget _imagePlaceHolder(String? url) {
    return Column(children: [
      const SizedBox(
        height: 238,
        width: 200,
        child: Icon(Icons.book, size: 150),
      ),
      bookTitle(url)
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

  Widget bookTitle(String? url) {
    // Determine the text color based on the URL
    Color? textColor = url != null && url.isNotEmpty ? Colors.white : null;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.book.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: textColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Author Text
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                      child: Icon(
                    Icons.person_outline,
                    size: 16,
                    color: textColor,
                  )),
                  TextSpan(
                    text: widget.book.authorName ?? "No name",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: textColor),
                  )
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
            // Author Text
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 270,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Stack(children: [
                if (url != null && url!.isNotEmpty)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageLoader(
                        url: url!,
                        fit: BoxFit.cover,
                        constraints: const BoxConstraints.expand(),
                      )),
                if (url == null || url!.isEmpty) _imagePlaceHolder(url),
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
                            child: bookTitle(url)),
                      )),
              ]))
            ]));
  }
}
