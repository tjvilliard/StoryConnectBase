import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/comments/components/navigate_button.dart';
import 'package:storyconnect/Widgets/horizontal_divider.dart';

class SuggestionWidget extends StatelessWidget {
  final Comment comment;

  SuggestionWidget({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 150),
        child: Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Chapter ${comment.chapterId}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .apply(fontStyle: FontStyle.italic)),
                            if (comment.isGhost() == false)
                              NavigateToFeedbackButton(
                                suggestion: comment,
                              )
                          ]),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(minHeight: 50, maxHeight: 100),
                      alignment: Alignment.center,
                      child: Text(comment.comment ?? "No comment",
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Divider(
                              color: Theme.of(context).dividerColor,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // decline button
                                    FilledButton.tonalIcon(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.x),
                                        label: Text("Decline",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium)),
                                    HorizontalDivider(height: 30),

                                    // accept button
                                    FilledButton.tonalIcon(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.check),
                                        label: Text("Accept",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium)),
                                  ],
                                ))
                          ],
                        ))
                  ],
                ))));
  }
}
