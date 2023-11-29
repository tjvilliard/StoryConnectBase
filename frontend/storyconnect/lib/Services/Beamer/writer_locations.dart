import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/state/continuity_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/pages_repository.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Pages/writing_app/view.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Pages/book_creation/view.dart';
import 'package:storyconnect/Pages/writing_home/view.dart';
import 'package:storyconnect/Pages/writing_home/state/writing_home_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:storyconnect/Services/Beamer/custom_beam_page.dart';
import 'package:storyconnect/Services/url_service.dart';

class WriterLocations extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        PageUrls.writerHome,
        PageUrls.createBook,
        '${PageUrls.writerBase}/book/:bookId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <CustomBeamPage>[];
    final url = state.uri.pathSegments;
    final baseUrlString = PageUrls.writerBase.split('/').last;

    if (url.contains(baseUrlString)) {
      final String createUrl = PageUrls.getLastPathSegment(PageUrls.createBook);
      final String homeUrl = PageUrls.getLastPathSegment(PageUrls.writerHome);

      if (url.contains(createUrl)) {
        pages.add(
          CustomBeamPage(
            key: ValueKey(createUrl),
            child: BlocProvider(
              create: (context) => BookCreateBloc(context.read<WritingRepository>()),
              child: const WritingCreationView(),
            ),
          ),
        );
      } else if (state.pathParameters.containsKey('bookId')) {
        final bookId = state.pathParameters['bookId'];
        pages.add(CustomBeamPage(
            key: ValueKey('book-$bookId'),
            child: MultiRepositoryProvider(
                providers: [
                  RepositoryProvider<BookProviderRepository>(
                    lazy: false,
                    create: (_) => BookProviderRepository(bookId: int.tryParse(bookId!) ?? 0),
                  ),
                  RepositoryProvider<RoadUnblockerRepo>(
                    lazy: false,
                    create: (_) => RoadUnblockerRepo(),
                  ),
                ],
                child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          lazy: false, create: (context) => WritingBloc(context.read<BookProviderRepository>())),
                      BlocProvider(
                          lazy: false, create: (_) => WritingUIBloc(repository: context.read<WritingRepository>())),
                      BlocProvider<FeedbackBloc>(create: (context) => FeedbackBloc(context.read<WritingRepository>())),
                      BlocProvider<RoadUnblockerBloc>(
                          create: (context) =>
                              RoadUnblockerBloc(repo: context.read<RoadUnblockerRepo>(), chapterContent: "")),
                      BlocProvider(create: (context) => ContinuityBloc(repo: context.read<WritingRepository>()))
                    ],
                    child: WritingAppView(
                      bookId: int.tryParse(bookId ?? ""),
                    )))));
      } else if (url.contains(homeUrl)) {
        pages.add(
          CustomBeamPage(
            key: const ValueKey('writer-home'),
            child: BlocProvider(
              create: (context) => WritingHomeBloc(context.read<WritingRepository>()),
              child: const WritingHomeWidget(),
            ),
          ),
        );
      } else {
        if (kDebugMode) {
          print("Not Found");
        }
      }
    }

    return pages;
  }
}
