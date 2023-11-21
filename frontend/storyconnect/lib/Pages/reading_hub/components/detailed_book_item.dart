import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Models/models.dart';

class NewDescriptBookItem extends StatelessWidget {
  final Book book;

  /// Creates a clickable book item filled in with details based on the provided book.
  const NewDescriptBookItem({super.key, required this.book});

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  Widget _topRightHandDetail({required Widget textItem}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 0.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190.0, maxHeight: 190.0),
              child: textItem,
            )));
  }

  Widget _rightHandDetail({required Widget textItem}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190.0, maxHeight: 190.0),
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
            const Icon(
              Icons.book,
              size: 175,
            ),

            // Row Item 2: The Book Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topRightHandDetail(
                    textItem: Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                )),
                _rightHandDetail(
                    textItem: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: [
                          const WidgetSpan(child: Icon(FontAwesomeIcons.person, size: 16)),
                          TextSpan(
                              text: book.authorName ?? "No Author Name",
                              style: TextStyle(fontFamily: GoogleFonts.ramabhadra().fontFamily))
                        ]))),
                _rightHandDetail(
                    textItem: Text(book.synopsis == null ? "" : book.synopsis!,
                        maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)))
              ],
            )
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(left: 31.0, right: 31.0),
            child: Wrap(
              runSpacing: 4.0,
              spacing: 4.0,
              children: [
                const TagWidget(
                  tagCategory: TagCategories.genre,
                  tagText: "Tragic Romance",
                ),
                const TagWidget(
                  tagCategory: TagCategories.genre,
                  tagText: "Dystopia ",
                ),
                const TagWidget(
                  tagCategory: TagCategories.genre,
                  tagText: "Science Fiction ",
                ),
                const TagWidget(
                  tagCategory: TagCategories.genre,
                  tagText: "Science Fantasy ",
                ),
                const TagWidget(
                  tagCategory: TagCategories.genre,
                  tagText: "Drama",
                ),
                TagWidget(
                  tagCategory: TagCategories.filter,
                  tagText: book.language,
                ),
                TagWidget(
                  tagCategory: TagCategories.filter,
                  tagText: "Modified: ${yyMMddDateTime(book.modified)}",
                ),
                TagWidget(
                  tagCategory: TagCategories.filter,
                  tagText: "Created: ${yyMMddDateTime(book.created)}",
                ),
                const TagWidget(
                  tagCategory: TagCategories.manual,
                  tagText: "Humor",
                ),
              ],
            )), // Bottom Row Items: Tag Items
      ],
    );
  }
}

const Color charcoalBlue = Color(0xFF28536B);
const Color rosyRed = Color.fromARGB(255, 196, 64, 84);
const Color yellow = Color.fromARGB(255, 171, 169, 59);

enum TagCategories {
  genre(charcoalBlue),
  filter(rosyRed),
  manual(yellow);

  const TagCategories(this.color);
  final Color color;
}

///
class TagWidget extends StatelessWidget {
  final TagCategories tagCategory;
  final String tagText;

  const TagWidget({super.key, required this.tagCategory, required this.tagText});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minHeight: 20),
        decoration: BoxDecoration(
          border: Border.all(width: .75, color: tagCategory.color),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(tagText, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ));
  }
}
