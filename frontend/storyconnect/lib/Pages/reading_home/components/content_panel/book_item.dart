import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyconnect/Models/models.dart';

abstract class BookItem extends StatelessWidget {}

/// Clickable Book Item, has sample text synopsis, book author and title, and descript set of tags.
class DescriptBookItem extends BookItem {
  final Book book;

  DescriptBookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.book,
              size: 175,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                    child: Text(
                      this.book.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: RichText(
                        text: TextSpan(children: [
                      WidgetSpan(child: Icon(Icons.person_outline, size: 16)),
                      TextSpan(
                          text: "Author",
                          style: TextStyle(
                              fontFamily: GoogleFonts.ramabhadra().fontFamily))
                    ]))),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 200, maxHeight: 200),
                        child: Text(
                          "Synopsis",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ))),
              ],
            )
          ],
        ),
        // Tags List
      ],
    );
  }
}

/// Clickable book Item, featuring only the cover, title, and author.
class CoverBookItem extends BookItem {
  final Book book;

  CoverBookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        Icons.book,
        size: 175,
      ),
      Text(this.book.title),
      RichText(
          text: TextSpan(children: [
        WidgetSpan(child: Icon(Icons.person_outline, size: 16)),
        TextSpan(
            text: "Author",
            style: TextStyle(fontFamily: GoogleFonts.ramabhadra().fontFamily))
      ])),
    ]);
  }
}
