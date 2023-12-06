import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_buttons_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_chapters_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_cover.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_title_card.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';

class BookDetailsView extends StatefulWidget {
  static const double mainCardElevation = 4.0;
  static const double secondaryCardElevation = 6.0;
  static const double mainCardWidth = 800.0;
  static const double secondaryCardWidth = 325.0;
  static const double mainCardPadding = 40.0;
  static const double secondaryCardPadding = 8.0;

  final int? bookId;
  const BookDetailsView({
    super.key,
    required this.bookId,
  });

  @override
  State<StatefulWidget> createState() => BookDetailsViewState();
}

class BookDetailsViewState extends State<BookDetailsView> {
  @override
  void initState() {
    Bloc bloc = context.read<BookDetailsBloc>();
    bloc.add(LoadBookDetailsEvent(bookId: widget.bookId));
    bloc.add(LoadBookChaptersEvent(bookId: widget.bookId));

    LibraryBloc libBloc = context.read<LibraryBloc>();
    libBloc.add(const FetchLibraryBooksEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(),
        navigateBackFunction: () {
          final bool canBeam = Beamer.of(context).beamBack();
          if (!canBeam) {
            Beamer.of(context).beamToNamed(PageUrls.readerHome);
          }
        },
        body: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          const BookDetailsTitleCard(),
          Body(
              child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 4,
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minWidth: 325.0,
                                    maxWidth: 325.0,
                                    minHeight: 325.0),
                                child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BookDetailsCover(),
                                      BookDetailsCard(),
                                    ])),
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxWidth: 325.0, minHeight: 325.0),
                                child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BookDetailsButtonsCard(),
                                      BookDetailsChaptersCard(),
                                    ])),
                          ]))))
        ])));
  }
}
