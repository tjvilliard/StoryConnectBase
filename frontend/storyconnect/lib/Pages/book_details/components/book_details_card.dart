import 'package:beamer/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsCard extends StatelessWidget {
  const BookDetailsCard({super.key});

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
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
                builder: (context, state) {
              Widget toReturn;

              if (state.bookDetailsLoadingStruct.isLoading) {
                toReturn = Align(
                  alignment: Alignment.center,
                  child: LoadingWidget(
                      loadingStruct: state.bookDetailsLoadingStruct),
                );
              } else {
                if (state.book == null) {
                  toReturn = const SizedBox.shrink();
                } else {
                  toReturn = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Language: ${state.book!.language}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Text(
                            "Audience: ${TargetAudience.values[state.book!.targetAudience].label}"),
                        const SizedBox(height: 20),
                        Row(children: [
                          const Icon(
                            size: 18,
                            Icons.person_outline,
                          ),
                          const SizedBox(width: 4),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                text: state.book!.authorName ??
                                    " Author Name Not Set.",
                                recognizer: state.book!.authorName == null
                                    ? null
                                    : TapGestureRecognizer()
                                  ?..onTap = () {
                                    final uri =
                                        PageUrls.writerProfile(state.uuid);
                                    Beamer.of(context).beamToNamed(uri);
                                  })
                          ])),
                        ]),
                        const SizedBox(height: 20),
                        Text(
                            style: Theme.of(context).textTheme.bodyMedium,
                            "Created: ${yyMMddDateTime(state.book!.created)}"),
                        const SizedBox(height: 20),
                        Text(
                            style: Theme.of(context).textTheme.bodyMedium,
                            "Updated: ${yyMMddDateTime(state.book!.modified)}"),
                        const SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.copyright),
                              const SizedBox(width: 4),
                              Flexible(
                                  child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      copyrightOptionFromInt(
                                              state.book!.copyright)!
                                          .description)),
                            ]),
                        const SizedBox(height: 10),
                        const Divider(
                          indent: 16,
                          endIndent: 16,
                        ),
                        const SizedBox(height: 10),
                        Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(
                              state.book!.synopsis ?? "",
                              maxLines: 28,
                            )),
                      ]);
                }
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: toReturn,
              );
            })));
  }
}
