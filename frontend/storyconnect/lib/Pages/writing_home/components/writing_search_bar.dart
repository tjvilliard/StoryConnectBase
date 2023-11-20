import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_home/state/writing_home_bloc.dart';
import 'package:storyconnect/Widgets/auto_complete_searchbar.dart';

class WritingSearchBar extends StatefulWidget {
  const WritingSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WritingSearchBarState();
  }
}

class WritingSearchBarState extends State<WritingSearchBar> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<WritingHomeBloc, WritingHomeState>(builder: (context, state) {
          return AutoCompleteSearchBar(
            hintText: "Search",
            searchableItems: state.books.map((Book book) => book.title.toLowerCase().trim()).toList(),
            searchCallback: (String value) {
              context.read<WritingHomeBloc>().add(SearchBooksEvent(value));
            },
          );
        }));
  }
}
