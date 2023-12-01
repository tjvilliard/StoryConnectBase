import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:storyconnect/Pages/book_details/components/book_detail_cover.dart';
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
    context
        .read<BookDetailsBloc>()
        .add(FetchBookDetailsEvent(bookId: widget.bookId));

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
                  Header(
                    title: state.book!.title,
                    alignment: WrapAlignment.center,
                  ),
                  Body(
                      child: Card(
                          surfaceTintColor: Colors.white,
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BookDetailsCover(book: state.book!),
                                    const SizedBox(height: 20),
                                    Text("Language: ${state.book!.language}"),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        onPressed: () {
                                          final uri = PageUrls.writerProfile(
                                              state.uuid!);
                                          Beamer.of(context).beamToNamed(uri);
                                        },
                                        child: Text(state.book!.authorName ??
                                            "Author Name Not Set.")),
                                    const SizedBox(height: 20),
                                    if (state.bookTags != null)
                                      Text(state.bookTags!.tags.toString()),
                                    const SizedBox(height: 20),
                                    Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(yyMMddDateTime(
                                                state.book!.created)),
                                            const VerticalDivider(
                                              indent: 2.5,
                                              endIndent: 2.5,
                                              width: 20,
                                            ),
                                            Text(yyMMddDateTime(
                                                state.book!.modified)),
                                          ],
                                        )),
                                    const SizedBox(height: 20),
                                    Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 450),
                                        child: Text(
                                          state.book!.synopsis ?? "",
                                          maxLines: 7,
                                        )),
                                    Text(state.book!.copyright.toString()),
                                  ],
                                )
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
