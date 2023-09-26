import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/sign_in/view.dart';
import 'package:storyconnect/Pages/reading_home/reading_home_bloc.dart';
import 'package:storyconnect/Pages/reading_home/view.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';

class ReaderLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/',
        '/reader/home',
        '/reader/book/:bookId',
        '/reader/book/:bookId/:chapterId'
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;

    if (url.contains('reader')) {
      if (url.contains('home')) {
        pages.add(CustomBeamPage(
            key: ValueKey('reader'),
            child: BlocProvider(
              create: (context) =>
                  ReadingHomeBloc(context.read<ReadingRepository>()),
              child: ReadingHomeView(),
            )));
      }
    } else if (state.uri.pathSegments.isEmpty) {
      pages.add(
          CustomBeamPage(key: const ValueKey('login'), child: LoginPage()));
    }

    return pages;
  }
}
