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
                  } else if (state.queryResults.isEmpty && !state.initLoad) {
                    toReturn = const Card(
                      elevation: 4,
                      child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: SizedBox(
                              height: 50,
                              width: 200,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "No results found matching your search.")))),
                    );
                  } else {
                    toReturn = SizedBox(
                        height: MediaQuery.of(context).size.height - 325,
                        child: SingleChildScrollView(
                          child: Column(
                              children: state.queryResults
                                  .map((book) => BigBookWidget(book: book))
                                  .toList()),
                        ));
                  }

                  return Column(children: [
                    const BookSearchBar(),
                    const SizedBox(height: 32),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LanguageDropdown(),
                          SizedBox(width: 16),
                          CopyrightDropdown(),
                          SizedBox(width: 16),
                          AudienceDropdown(),
                        ]),
                    const SizedBox(height: 64),
                    toReturn,
                  ]);
                }))));
  }
}
