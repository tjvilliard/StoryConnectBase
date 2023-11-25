import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/book_widgets/book_widget.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class CurrentWorksCard extends StatelessWidget {
  const CurrentWorksCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 550, minWidth: 400),
        height: 300,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                    "Most Recent Works",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                      height: 20), // horizontally scrollable list of books

                  BlocBuilder<WriterProfileBloc, WriterProfileState>(
                      builder: (context, state) {
                    Widget toReturn;
                    if (state.loadingStructs.booksLoadingStruct.isLoading ==
                        true) {
                      toReturn = LoadingWidget(
                          loadingStruct:
                              state.loadingStructs.booksLoadingStruct);
                    } else {
                      if (state.books.isEmpty) {
                        toReturn = const Text("No books found");
                      } else {
                        toReturn = ListView.separated(
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 20);
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: min(state.books.length, 6),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                  width: 150,
                                  height: 200,
                                  child: BookWidget(book: state.books[index]));
                            });
                      }
                    }
                    return Expanded(
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: toReturn));
                  })
                ]))));
  }
}
