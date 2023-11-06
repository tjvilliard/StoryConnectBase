import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/state/reading_home_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/view.dart';
import 'package:storyconnect/Pages/login/sign_in/view.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_pages_repository.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/view.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/view.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

/// Handles the beamer locations for Reader Functions.
class ReaderLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
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
            key: ValueKey('reader'),
            child: BlocProvider(
              create: (context) =>
                  ReadingHomeBloc(context.read<ReadingRepository>()),
              child: ReadingHomeView(),
            )));
      }
      // If the url contains library, send the reader to the library.
      else if (url.contains('library')) {
        pages.add(CustomBeamPage(
            key: ValueKey('library'),
            child: BlocProvider(
              create: (context) =>
                  LibraryBloc(context.read<ReadingRepository>()),
              child: LibraryView(),
            )));
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
                    create: (_) => BookProviderRepository(
                        bookID: int.tryParse(bookId!) ?? 0),
                  ),
                ],
                child: MultiBlocProvider(
                    providers: [
                      BlocProvider<ChapterBloc>(
                          lazy: false,
                          create: (context) => ChapterBloc(
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
        print("Didn't find page 1:");
      }
    }
    // If the segments are empty, send the reader to the login page.
    else if (state.uri.pathSegments.isEmpty) {
      pages.add(
          CustomBeamPage(key: const ValueKey('login'), child: LoginPage()));
    } else {
      print("Didn't find page");
    }

    // else send the reader to the reader's not found page.
    // TODO: add Reader's 404-'Not Found' page to the reader functions. Make it cute.

    return pages;
  }
}
