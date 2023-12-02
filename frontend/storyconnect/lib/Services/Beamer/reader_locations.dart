import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/state/reading_hub_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/view.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_pages_repository.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/view.dart';
import 'package:storyconnect/Pages/reading_hub/library/view.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

/// Handles the beamer locations for Reader Functions.
class ReaderLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/reader/home',
        '/reader/library',
        '/reader/details/:bookId',
        '/reader/book/:bookId',
        '/reader/book/:bookId/:chapterIndex'
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;

    print("Adding Page");

    // If the url contains 'reader' as a primary segment.
    if (url.contains('reader')) {
      // If the url contains home, send the reader home.
      if (url.contains('home')) {
        pages.add(CustomBeamPage(
          key: const ValueKey('reader'),
          child: MultiBlocProvider(providers: [
            BlocProvider(
                create: (context) =>
                    ReadingHubBloc(context.read<ReadingRepository>())),
          ], child: const ReadingHomeView()),
        ));
      }
      // If the url contains library, send the reader to the library.
      else if (url.contains('library')) {
        pages.add(CustomBeamPage(
            key: const ValueKey('library'),
            child: BlocProvider(
              create: (context) =>
                  ReadingHubBloc(context.read<ReadingRepository>()),
              child: const LibraryView(),
            )));
      }
      // If the url contains a path parameter 'bookId'
      else if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        final chapterIndex = state.pathParameters['chapterIndex'];

        if (url.contains('book')) {
          if (state.pathParameters.containsKey('chapterIndex')) {
            print("Found?");
            print(state.routeInformation.toString());
            print(state.pathPatternSegments);
            print(state.pathParameters);
          } else {}

          pages.add(CustomBeamPage(
              key: ValueKey('book-$bookId'),
              child: MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(
                      lazy: false,
                      create: (_) => BookProviderRepository(
                          bookID: int.tryParse(bookId!) ?? 0),
                    ),
                  ],
                  child: MultiBlocProvider(
                      providers: [
                        BlocProvider<ReadingHubBloc>(
                            lazy: false,
                            create: (context) => ReadingHubBloc(
                                context.read<ReadingRepository>())),
                        BlocProvider<ReadingBloc>(
                            lazy: false,
                            create: (context) => ReadingBloc(
                                context.read<BookProviderRepository>())),
                        BlocProvider<FeedbackBloc>(
                            lazy: false,
                            create: (context) => FeedbackBloc(
                                context.read<ReadingRepository>())),
                        BlocProvider<ReadingUIBloc>(
                            lazy: false,
                            create: (context) => ReadingUIBloc(
                                repository: context.read<ReadingRepository>())),
                      ],
                      child: ReadingAppView(
                        bookId: int.tryParse(bookId ?? ""),
                        chapterIndex: int.tryParse(chapterIndex ?? ""),
                      )))));
        } else if (url.contains('details')) {
          pages.add(CustomBeamPage(
            key: ValueKey('book-details-$bookId'),
            child: MultiBlocProvider(
                providers: [
                  BlocProvider<BookDetailsBloc>(
                      lazy: false,
                      create: (context) =>
                          BookDetailsBloc(context.read<ReadingRepository>())),
                  BlocProvider<ReadingHubBloc>(
                      lazy: false,
                      create: (context) =>
                          ReadingHubBloc(context.read<ReadingRepository>()))
                ],
                child: BookDetailsView(
                  bookId: int.tryParse(bookId ?? ""),
                )),
          ));
        }
      } else {
        if (kDebugMode) {
          print("Not Found: Reader");
        }
      }
    }

    return pages;
  }
}
