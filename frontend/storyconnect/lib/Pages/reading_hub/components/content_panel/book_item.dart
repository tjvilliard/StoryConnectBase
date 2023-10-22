import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyconnect/Models/models.dart';

abstract class BookItem extends StatelessWidget {}

/// Clickable book Item, featuring only the cover, title, and author.
class CoverBookItem extends BookItem {
  final Book book;

  CoverBookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book,
                size: 175,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: (270.0 / 1.618) + 35),
                child: Text(
                  this.book.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.person_outline, size: 16)),
                      TextSpan(
                          text: "Author",
                          style: TextStyle(
                              fontFamily: GoogleFonts.ramabhadra().fontFamily))
                    ],
                  )),
            ]));
  }
}
