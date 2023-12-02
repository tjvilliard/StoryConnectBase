import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_card.dart';
import 'package:storyconnect/Pages/book_details/components/book_details_cover.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsView extends StatefulWidget {
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
    if (kDebugMode) {
      print("Details Init State");
    }
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
      body: SingleChildScrollView(
          child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
          if (state.loadingStruct.isLoading) {
            return LoadingWidget(loadingStruct: state.loadingStruct);
          } else {
            if (state.book == null) {
              return const Column(children: [Text("Not Found")]);
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            padding: const EdgeInsets.all(40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 350.0),
                                    child: Column(children: [
                                      BookDetailsCover(book: state.book!),
                                      const SizedBox(height: 20),
                                      BookDetailsCard(
                                        book: state.book,
                                        uuid: state.uuid,
                                        bookTags: state.bookTags,
                                      ),
                                    ])),
                                const SizedBox(
                                  width: 50,
                                  child: VerticalDivider(
                                    thickness: 1.0,
                                    indent: 0,
                                    endIndent: 0,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minHeight: 50,
                                          maxWidth: 300,
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                  child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        24),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        24),
                                                                topRight:
                                                                    Radius.zero,
                                                                bottomRight:
                                                                    Radius
                                                                        .zero))),
                                                child: const Text(
                                                    "Start Reading!"),
                                                onPressed: () {},
                                              )),
                                              Expanded(
                                                  child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        24),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            24),
                                                                topLeft:
                                                                    Radius.zero,
                                                                bottomLeft:
                                                                    Radius
                                                                        .zero))),
                                                child: const Text("Library"),
                                                onPressed: () {},
                                              )),
                                            ])),
                                    const SizedBox(height: 20),
                                    Card(
                                        elevation: 4.0,
                                        child: Column(children: [
                                          SizedBox(
                                            height: 50,
                                            child: Text(
                                              "Chapters",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 300,
                                              height: 800,
                                              child: ListView.builder(
                                                  itemCount:
                                                      state.chapters.length,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                              height: 40,
                                                              width: 200,
                                                              child:
                                                                  ElevatedButton(
                                                                child: Text(
                                                                    "Chapter ${index + 1}: ${state.chapters[index].chapterTitle}"),
                                                                onPressed:
                                                                    () {},
                                                              ))))),
                                        ])),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                ],
              );
            }
          }
        },
      )),
    );
  }
}
