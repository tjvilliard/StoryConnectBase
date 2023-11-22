import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/view.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_pages_repository.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/view.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/view.dart';
import 'package:storyconnect/Repositories/library_repository.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

/// Handles the beamer locations for Reader Functions.
class ReaderLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/reader/home',
        '/reader/library',
        '/reader/book/:bookId',
        '/reader/book/:bookId/:chapterId'
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;

    // If the url contains 'reader' as a primary segment.
    if (url.contains('reader')) {
      // If the url contains home, send the reader home.
      if (url.contains('home')) {
        pages.add(CustomBeamPage(
            key: const ValueKey('reader'),
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider(create: (_) => LibraryRepository()),
              ],
              child: MultiBlocProvider(providers: [
                BlocProvider(
                    create: (context) =>
                        ReadingHomeBloc(context.read<ReadingRepository>())),
                BlocProvider(
                    create: (context) =>
                        LibraryBloc(context.read<LibraryRepository>())),
              ], child: const ReadingHomeView()),
            )));
      }
      // If the url contains library, send the reader to the library.
      else if (url.contains('library')) {
        pages.add(CustomBeamPage(
            key: const ValueKey('library'),
            child: RepositoryProvider(
                lazy: false,
                create: (_) => LibraryRepository(),
                child: BlocProvider(
                  create: (context) =>
                      LibraryBloc(context.read<LibraryRepository>()),
                  child: const LibraryView(),
                ))));
      }
      // If the url contains a path parameter 'bookId'
      else if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        pages.add(CustomBeamPage(
            key: ValueKey('book-$bookId'),
            child: MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(
                    lazy: false,
                    create: (_) => LibraryRepository(),
                  ),
                  RepositoryProvider(
                    lazy: false,
                    create: (_) => BookProviderRepository(
                        bookID: int.tryParse(bookId!) ?? 0),
                  ),
                ],
                child: MultiBlocProvider(
                    providers: [
                      BlocProvider<LibraryBloc>(
                          lazy: false,
                          create: (context) =>
                              LibraryBloc(context.read<LibraryRepository>())),
                      BlocProvider<ReadingBloc>(
                          lazy: false,
                          create: (context) => ReadingBloc(
                              context.read<BookProviderRepository>())),
                      BlocProvider<FeedbackBloc>(
                          lazy: false,
                          create: (context) =>
                              FeedbackBloc(context.read<ReadingRepository>())),
                      BlocProvider<ReadingUIBloc>(
                          lazy: false,
                          create: (context) => ReadingUIBloc(
                              repository: context.read<ReadingRepository>())),
                    ],
                    child: ReadingAppView(
                      bookId: int.tryParse(bookId ?? ""),
                    )))));
      } else {
        if (kDebugMode) {
          print("Not Found: Reader");
        }
      }
    }

    return pages;
  }
}
