import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_buttons_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_chapters_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_cover.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

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
    bloc.add(FetchBookDetailsEvent(bookId: widget.bookId));
    bloc.add(FetchBookChaptersEvent(bookId: widget.bookId));

    super.initState();
  }

  String yyMMddDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd();
    String formatted = formatter.format(dateTime);
    return formatted;
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
        body: SingleChildScrollView(child:
            BlocBuilder<BookDetailsBloc, BookDetailsState>(
                builder: (context, state) {
          if (state.loadingBookStruct.isLoading ||
              state.loadingChaptersStruct.isLoading) {
            return LoadingWidget(loadingStruct: state.loadingBookStruct);
          } else {
            if (state.book == null) {
              return const Column(children: [Text("Not Found")]);
            } else {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 4,
                      child: Header(
                        title: state.book!.title,
                        alignment: WrapAlignment.center,
                      )),
                ),
                Body(
                    child: Card(
                        surfaceTintColor: Colors.white,
                        elevation: 4,
                        child: Container(
                            padding: const EdgeInsets.all(32),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxWidth: 325.0, minHeight: 325.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BookDetailsCover(book: state.book!),
                                            const SizedBox(height: 20),
                                            BookDetailsCard(
                                              book: state.book,
                                              uuid: state.uuid,
                                              bookTags: state.bookTags,
                                            ),
                                          ])),
                                  ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxWidth: 325.0, minHeight: 325.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BookDetailsButtonsCard(
                                                bookId: widget.bookId),
                                            const SizedBox(height: 20),
                                            BookDetailsChaptersCard(
                                                bookId: widget.bookId!,
                                                chapters: state.chapters!),
                                          ])),
                                ]))))
              ]);
            }
          }
        })));
  }
}
