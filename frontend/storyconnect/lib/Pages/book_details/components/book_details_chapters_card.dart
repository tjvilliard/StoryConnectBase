import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsChaptersCard extends StatelessWidget {
  final int bookId;
  final List<Chapter> chapters;
  const BookDetailsChaptersCard({
    super.key,
    required this.bookId,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: BookDetailsView.secondaryCardElevation,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              /*
              ElevatedButton(
                  onPressed: () {
                    final uri = PageUrls.readBookByChapter(bookId, 0);
                    BeamerDelegate b = Beamer.of(context);
                    b.beamToNamed(uri, data: {"book": bookId});
                  },
                  child: const Text("Debug Button Chapter beam")),
                  */
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 75.0,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Icon(
                            size: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize! *
                                1.5,
                            Icons.list),
                        const SizedBox(width: 10),
                        Text(
                          style: Theme.of(context).textTheme.titleLarge,
                          "Table of Contents",
                        )
                      ]))),
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 200.0,
                    maxHeight: 850.0,
                  ),
                  child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
                      builder: (context, state) {
                    if (state.loadingChaptersStruct.isLoading) {
                      return LoadingWidget(
                          loadingStruct: state.loadingChaptersStruct);
                    } else {
                      return ListView.builder(
                          itemCount: chapters.length,
                          itemBuilder: (context, index) => SizedBox(
                              height: 75,
                              width: 200,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text(
                                        overflow: TextOverflow.fade,
                                        "Chapter ${index + 1}: ${chapters[index].chapterTitle}"),
                                    onPressed: () {
                                      final uri = PageUrls.readBookByChapter(
                                          bookId, index);
                                      Beamer.of(context).beamToNamed(uri,
                                          data: {"book": bookId});
                                    },
                                  ))));
                    }
                  })),
            ])));
  }
}
