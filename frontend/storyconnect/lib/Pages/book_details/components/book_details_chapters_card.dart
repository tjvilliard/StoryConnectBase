import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Pages/book_details/view.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsChaptersCard extends StatelessWidget {
  const BookDetailsChaptersCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: BookDetailsView.secondaryCardElevation,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
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
                    minHeight: 250.0,
                    maxHeight: 850.0,
                  ),
                  child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
                      builder: (context, state) {
                    if (state.chapterLoadingStruct.isLoading) {
                      return LoadingWidget(
                          loadingStruct: state.chapterLoadingStruct);
                    } else {
                      return ListView.builder(
                          itemCount: state.chapters.length,
                          itemBuilder: (context, index) => SizedBox(
                              height: 75,
                              width: 200,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Text(
                                        overflow: TextOverflow.fade,
                                        "Chapter ${index + 1}: ${state.chapters[index].chapterTitle}"),
                                    onPressed: () {
                                      final uri = PageUrls.readBookByChapter(
                                          state.book!.id, index);
                                      Beamer.of(context).beamToNamed(uri,
                                          data: {"book": state.book!.id});
                                    },
                                  ))));
                    }
                  })),
            ])));
  }
}
