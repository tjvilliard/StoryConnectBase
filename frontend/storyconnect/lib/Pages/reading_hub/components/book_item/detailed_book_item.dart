import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyconnect/Models/models.dart';

class newDescriptBookItem extends StatelessWidget {
  final Book book;

  /// Creates a clickable book item filled in with details based on the provided book.
  newDescriptBookItem({required this.book});

  Widget _topRightHandDetail({required Widget textItem}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 0.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 190.0, maxHeight: 190.0),
              child: textItem,
            )));
  }

  Widget _rightHandDetail({required Widget textItem}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 190.0, maxHeight: 190.0),
              child: textItem,
            )));
  }

  @override
  Widget build(BuildContext context) {
    // Two Column Items in layout: The top half with
    // the book cover, title, author, num chapters, and synopsis.
    // The Bottom Half, the book tags.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row Items:
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Item 1: The Book Image
            Icon(
              Icons.book,
              size: 175,
            ),

            // Row Item 2: The Book Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                this._topRightHandDetail(
                    textItem: Text(
                  this.book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                )),
                this._rightHandDetail(
                    textItem: RichText(
                  text: TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.list, size: 16)),
                    TextSpan(
                        text: " ${5} Chapters",
                        style: TextStyle(
                            fontFamily: GoogleFonts.ramabhadra().fontFamily)),
                  ]),
                )),
                this._rightHandDetail(
                    textItem: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Icon(Icons.person_outline, size: 16)),
                          TextSpan(
                              text: this.book.author == null
                                  ? ""
                                  : this.book.author,
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.ramabhadra().fontFamily))
                        ]))),
                this._rightHandDetail(
                    textItem: Text(book.synopsis == null ? "" : book.synopsis!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12)))
              ],
            )
          ],
        ),
        Container(), // Bottom Row Items: Tag Items
      ],
    );
  }
}
