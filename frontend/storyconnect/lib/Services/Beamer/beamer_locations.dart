import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/pages_repository.dart';
import 'package:storyconnect/Pages/writing_app/view.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_home/view.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Pages/writing_home/writing_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

class WriterLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/login',
        '/writer',
        '/writer/:bookId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];

    if (state.uri.pathSegments.contains('writer')) {
      if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        pages.add(CustomBeamPage(
            key: ValueKey('book-$bookId'),
            child: RepositoryProvider(
                lazy: false,
                create: (_) =>
                    PagesProviderRepository(bookId: int.tryParse(bookId!) ?? 0),
                child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          lazy: false,
                          create: (context) => PageBloc(
                              context.read<PagesProviderRepository>())),
                      BlocProvider(
                          lazy: false,
                          create: (context) => ChapterBloc(
                              context.read<PagesProviderRepository>())),
                      BlocProvider(
                          lazy: false,
                          create: (_) => WritingUIBloc(
                              repository: context.read<WritingRepository>())),
                    ],
                    child: WritingAppView(
                      bookId: int.tryParse(bookId ?? ""),
                    )))));
      } else {
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
      pages.add(CustomBeamPage(
          key: const ValueKey('login'),
          child: Scaffold(
              body: Center(
                  child: OutlinedButton(
            child: Text("Should be login page"),
            onPressed: () {
              Beamer.of(context).beamToNamed('/writer');
            },
          )))));
    }

    return pages;
  }
}
