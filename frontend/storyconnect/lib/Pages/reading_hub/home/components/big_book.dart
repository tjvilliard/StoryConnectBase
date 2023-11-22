import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reading_hub/library/components/library_book_cover.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/clickable.dart';

class BigBook extends StatelessBookItem {
  static const double sizeFactor = 1.1;
  static const double height = 200.0 * BigBook.sizeFactor;
  static const double width = 400.0 * BigBook.sizeFactor;
  static const double iconSize = 175.0 * BigBook.sizeFactor;
  static const double cardElevation = 3;
  static const double maxColumnWidth = width / 2.0;
  static const double synopsisBoxHeight = height / 2.0;
  final Book book;

  const BigBook({super.key, required this.book});

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    double smallIconSize = Theme.of(context).textTheme.bodySmall!.fontSize! + 3;

    return SizedBox(
        height: BigBook.height,
        width: BigBook.width,
        child: Card(
            elevation: BigBook.cardElevation,
            child: Clickable(
              onPressed: () {
                final uri = PageUrls.readBook(book.id);
                Beamer.of(context).beamToNamed(uri, data: {"book": book});
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.book,
                    size: BigBook.iconSize,
                  ),
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: BigBook.maxColumnWidth),
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
                                  maxHeight: BigBook.synopsisBoxHeight),
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
