import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/search/components/book_search_bar.dart';
import 'package:storyconnect/Pages/reading_hub/search/components/dropdown_filters.dart';
import 'package:storyconnect/Pages/reading_hub/search/state/search_bloc.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:storyconnect/Widgets/book_widgets/big_book.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<StatefulWidget> createState() => SearchDialogState();
}

class SearchDialogState extends State<SearchDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: BlocProvider(
                create: (context) =>
                    SearchBloc(context.read<ReadingRepository>()),
                child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                  Widget toReturn;

                  if (state.loadingStruct.isLoading) {
                    toReturn =
                        LoadingWidget(loadingStruct: state.loadingStruct);
                  } else {
                    toReturn = ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: 600, maxWidth: 450, minHeight: 400),
                        child: ListView.builder(
                            itemCount: state.queryResults.length,
                            itemBuilder: (context, index) {
                              return ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: BigBookWidget(
                                    book: state.queryResults[index]),
                              );
                            }));
                  }

                  return Column(children: [
                    const BookSearchBar(),
                    const SizedBox(height: 16),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LanguageDropdown(),
                          SizedBox(width: 16),
                          CopyrightDropdown(),
                          SizedBox(width: 16),
                          AudienceDropdown(),
                        ]),
                    const SizedBox(height: 16),
                    toReturn,
                  ]);
                }))));
  }
}
