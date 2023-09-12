import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/view.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/comments/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/pages_repository.dart';
import 'package:storyconnect/Pages/writing_app/view.dart';
import 'package:storyconnect/Pages/writing_app/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Pages/book_creation/view.dart';
import 'package:storyconnect/Pages/writing_home/view.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

class WriterLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/login',
        '/writer/home',
        '/writer/book/:bookId',
        '/writer/create_book',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;

    if (url.contains('writer')) {
      if (url.contains('create_book')) {
        pages.add(
          CustomBeamPage(
            key: ValueKey('create_book'),
            child: BlocProvider(
              create: (context) =>
                  BookCreateBloc(context.read<WritingRepository>()),
              child: WritingCreationView(),
            ),
          ),
        );
      } else if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        pages.add(CustomBeamPage(
            key: ValueKey('book-$bookId'),
            child: RepositoryProvider(
                lazy: false,
                create: (_) =>
                    BookProviderRepository(bookId: int.tryParse(bookId!) ?? 0),
                child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          lazy: false,
                          create: (context) => ChapterBloc(
                              context.read<BookProviderRepository>())),
                      BlocProvider(
                          lazy: false,
                          create: (_) => WritingUIBloc(
                              repository: context.read<WritingRepository>())),
                      BlocProvider<FeedbackBloc>(
                          create: (context) =>
                              FeedbackBloc(context.read<WritingRepository>()))
                    ],
                    child: WritingAppView(
                      bookId: int.tryParse(bookId ?? ""),
                    )))));
      } else if (url.contains('home')) {
        pages.add(
          CustomBeamPage(
            key: ValueKey('writer'),
            child: BlocProvider(
              create: (context) =>
                  WritingHomeBloc(context.read<WritingRepository>()),
              child: WritingHomeView(),
            ),
          ),
        );
      }
    }
    // hardcoded place to nowhere

    else if (state.uri.pathSegments.isEmpty) {
      pages.add(
          CustomBeamPage(key: const ValueKey('login'), child: LoginPage()));
    }

    return pages;
  }
}
