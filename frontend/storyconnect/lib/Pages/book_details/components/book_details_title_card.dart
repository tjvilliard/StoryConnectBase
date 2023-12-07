import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/book_details/state/book_details_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class BookDetailsTitleCard extends StatelessWidget {
  const BookDetailsTitleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 800, minWidth: 800, minHeight: 100, maxHeight: 200),
        child: Card(
            surfaceTintColor: Colors.white,
            elevation: 4,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
                    builder: (context, state) {
                  Widget toReturn;

                  if (state.bookDetailsLoadingStruct.isLoading) {
                    toReturn = LoadingWidget(
                        loadingStruct: state.bookDetailsLoadingStruct);
                  } else {
                    if (state.book == null) {
                      toReturn = Text(
                        "Not Found",
                        style: Theme.of(context).textTheme.displayMedium,
                      );
                    } else {
                      toReturn = Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        state.book!.title,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.displayMedium,
                      );
                    }
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: toReturn,
                  );
                }))));
  }
}
