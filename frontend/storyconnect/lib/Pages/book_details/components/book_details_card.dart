import 'package:beamer/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Models/genre_tagging/genre.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Services/url_service.dart';

class BookDetailsCard extends StatelessWidget {
  final Book? book;
  final String? uuid;
  final GenreTags? bookTags;

  const BookDetailsCard({
    super.key,
    required this.book,
    required this.uuid,
    required this.bookTags,
  });

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: BookDetailsView.secondaryCardElevation,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Language: ${book!.language}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              //
              RichText(
                  text: TextSpan(children: [
                const WidgetSpan(
                  child: Icon(
                    size: 16,
                    Icons.person_outline,
                  ),
                ),
                TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    text: book!.authorName ?? " Author Name Not Set.",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final uri = PageUrls.writerProfile(uuid!);
                        Beamer.of(context).beamToNamed(uri);
                      })
              ])),
              //
              const SizedBox(height: 20),

              // Book Tag Stuff
              if (bookTags != null) Text(bookTags!.tags.toString()),
              if (bookTags != null) const SizedBox(height: 20),
              // Book Tag Stuff

              Text(
                  style: Theme.of(context).textTheme.bodyMedium,
                  "Created: ${yyMMddDateTime(book!.created)}"),
              const SizedBox(height: 20),
              Text(
                  style: Theme.of(context).textTheme.bodyMedium,
                  "Last Edited: ${yyMMddDateTime(book!.modified)}"),

              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50),
                child: Text(
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                    copyrightOptionFromInt(book!.copyright)!.description),
              ),
              const SizedBox(height: 20),
              Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    book!.synopsis ?? "",
                    maxLines: 15,
                  )),
            ])));
  }
}
