import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/view.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_home/view.dart';
import 'package:storyconnect/Pages/writing_home/writing_home_bloc.dart';
import 'package:storyconnect/Pages/writing_home/writing_repository.dart';

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
    final pages = <BeamPage>[];

    if (state.uri.pathSegments.contains('writer')) {
      if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        pages.add(BeamPage(
            key: ValueKey('book-$bookId'),
            child: MultiBlocProvider(providers: [
              BlocProvider(lazy: false, create: (_) => PageBloc()),
              BlocProvider(lazy: false, create: (_) => ChapterBloc()),
              BlocProvider(lazy: false, create: (_) => WritingUIBloc()),
            ], child: WritingAppView())));
      } else {
        pages.add(
          BeamPage(
              key: ValueKey('writer'),
              child: RepositoryProvider(
                lazy: false,
                create: (_) => WritingHomeRepository(),
                child: BlocProvider(
                  create: (context) => WritingHomeBloc(
                      repository: context.read<WritingHomeRepository>()),
                  child: WritingHomeView(),
                ),
              )),
        );
      }
    }
    // hardcoded place to nowhere

    else if (state.uri.pathSegments.isEmpty) {
      pages.add(BeamPage(
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
