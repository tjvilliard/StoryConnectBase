
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/WritingApp/view.dart';
import 'package:storyconnect/Pages/WritingHome/view.dart';

class WriterLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/writer',
        '/writer/:bookId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[];

    if (state.uri.pathSegments.contains('writer')) {
      if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        pages.add(
          BeamPage(
            key: ValueKey('book-$bookId'),
            child: const WritingAppView(),
          ),
        );
      } else {
        pages.add(
          const BeamPage(key: ValueKey('writer'), child: WritingHomeView()),
        );
      }
    }
    // hardcoded place to nowhere
    else {
      pages.add(
        BeamPage(
            key: const ValueKey('nowhere'),
            child: Center(
                child: Text("This page is currently not implmeneted.",
                    style: Theme.of(context).textTheme.displayLarge))),
      );
    }
    return pages;
  }
}