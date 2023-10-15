import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyconnect/Models/models.dart';

abstract class BookItem extends StatelessWidget {}

/// Clickable Book Item, has sample text synopsis, book author and title, and descript set of tags.
class DescriptBookItem extends BookItem {
  DescriptBookItem(Book book);

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
              color: Colors.red,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                    child: Text(
                      "Book Title",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: RichText(
                        text: TextSpan(children: [
                      WidgetSpan(child: Icon(Icons.person_outline, size: 16)),
                      TextSpan(
                          text: " Book Author",
                          style: TextStyle(
                              fontFamily: GoogleFonts.ramabhadra().fontFamily))
                    ]))),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 200, maxHeight: 200),
                        child: Text(
                          "Nam quis nulla. Integer malesuada. In in enim a arcu imperdiet malesuada. Sed vel lectus. Donec odio urna, tempus molestie, porttitor ut, iaculis quis, sem. Phasellus rhoncus. Aenean id metus id velit ullamcorper pulvinar. Vestibulum fermentum tortor",
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

class CoverBookItem extends BookItem {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
