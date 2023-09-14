import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/view.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/pages_repository.dart';
import 'package:storyconnect/Pages/writing_app/view.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Pages/book_creation/view.dart';
import 'package:storyconnect/Pages/writing_home/view.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Services/Authentication/authentication_service.dart';
import 'package:storyconnect/Services/Authentication/authentication_wrapper.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

class WriterLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/login',
        '/writer/home',
        '/writer/:bookId',
        '/writer/create_book',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;
    final AuthenticationService authService = AuthenticationService();

    if (url.contains('writer')) {
      if (url.contains('create_book')) {
        BlocProvider createBookProvider = BlocProvider(
            create: (context) =>
                BookCreateBloc(context.read<WritingRepository>()),
            child: WritingCreationView());

        pages.add(
          CustomBeamPage(
            key: ValueKey('create_book'),
            child: AuthenticationWrapper(createBookProvider, false),
          ),
        );
      } else if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];

        RepositoryProvider bookProvider = RepositoryProvider(
            lazy: false,
            create: (_) =>
                PagesProviderRepository(bookId: int.tryParse(bookId!) ?? 0),
            child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                      lazy: false,
                      create: (context) =>
                          ChapterBloc(context.read<PagesProviderRepository>())),
                  BlocProvider(
                      lazy: false,
                      create: (_) => WritingUIBloc(
                          repository: context.read<WritingRepository>())),
                ],
                child: WritingAppView(
                  bookId: int.tryParse(bookId ?? ""),
                )));

        pages.add(CustomBeamPage(
            key: ValueKey('book-$bookId'),
            child: AuthenticationWrapper(bookProvider, true)));
      } else if (url.contains('home')) {
        BlocProvider homeBloc = BlocProvider(
          create: (context) =>
              WritingHomeBloc(context.read<WritingRepository>()),
          child: WritingHomeView(),
        );

        pages.add(CustomBeamPage(
            key: ValueKey('writer'),
            child: AuthenticationWrapper(homeBloc, true)));
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
