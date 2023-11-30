import 'package:beamer/beamer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';
import 'package:storyconnect/Widgets/image_loader.dart';

class BigBookWidget extends StatefulWidget {
  static const double sizeFactor = 1.1;
  static const double height = 200.0 * BigBookWidget.sizeFactor;
  static const double width = 400.0 * BigBookWidget.sizeFactor;
  static const double iconSize = 175.0 * BigBookWidget.sizeFactor;
  static const double cardElevation = 2;
  static const double maxColumnWidth = width / 2.0;
  static const double synopsisBoxHeight = height / 2.0;

  final Book book;

  const BigBookWidget({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => BigBookWidgetState();
}

class BigBookWidgetState extends State<BigBookWidget> {
  Book get book => widget.book;
  String? url;

  @override
  void initState() {
    getImage(widget.book.cover);
    super.initState();
  }

  Widget _imagePlaceHolder() {
    return const Column(children: [
      SizedBox(
        height: BigBookWidget.height - 8.0,
        width: BigBookWidget.width / 3.0,
        child: Icon(Icons.book, size: 150),
      )
    ]);
  }

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
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
    double smallIconSize = Theme.of(context).textTheme.bodySmall!.fontSize! + 3;

    return SizedBox(
        height: BigBookWidget.height,
        width: BigBookWidget.width,
        child: Card(
            elevation: BigBookWidget.cardElevation,
            child: Clickable(
              onPressed: () {
                final uri = PageUrls.readBook(book.id);
                Beamer.of(context).beamToNamed(uri, data: {"book": book});
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Placeholder
                  if (url == null || url!.isEmpty) _imagePlaceHolder(),
                  if (url != null && url!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageLoader(
                        url: url!,
                        fit: BoxFit.cover,
                        constraints: const BoxConstraints(
                          maxWidth: BigBookWidget.width / 3.0,
                          minHeight: BigBookWidget.height,
                        ),
                      ),
                    ),
                  const SizedBox(width: 20),
                  // Image Placeholder
                  Container(
                    constraints: const BoxConstraints(
                        maxWidth: BigBookWidget.maxColumnWidth),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Text Widget
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 12.0),
                            constraints: const BoxConstraints(
                              maxHeight: 40.0,
                            ),
                            child: Text(
                              book.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          // Title Text Widget

                          //Author Text Widget
                          Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              constraints: const BoxConstraints(
                                maxHeight: 30.0,
                              ),
                              child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        size: smallIconSize,
                                        Icons.person_outline,
                                      ),
                                    ),
                                    TextSpan(
                                      text: book.authorName ??
                                          "Author Name Not Set",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  ]))),
                          // Author Text Widget

                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 30.0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                // Chapter Info Text Widget
                                RichText(
                                    text: TextSpan(children: [
                                  WidgetSpan(
                                    child: Icon(
                                      size: smallIconSize,
                                      FontAwesomeIcons.list,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " 15",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ])),
                                // Chapter Info Text Widget

                                const VerticalDivider(
                                  indent: 2.5,
                                  endIndent: 2.5,
                                  width: 20,
                                ),

                                // Date Widget
                                RichText(
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        size: smallIconSize,
                                        FontAwesomeIcons.pen,
                                      ),
                                    ),
                                    TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        text:
                                            " ${yyMMddDateTime(book.modified)}"),
                                  ]),
                                ),
                                // Date Widget
                              ],
                            ),
                          ),

                          // Synopsis Text Widget
                          Container(
                              alignment: Alignment.topLeft,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              constraints: const BoxConstraints(
                                  maxHeight: BigBookWidget.synopsisBoxHeight),
                              child: Text(book.synopsis ?? "",
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.bodySmall)),
                          // Synopsis Text Widget
                        ]),
                  ),
                ],
              ),
            )));
  }
}
