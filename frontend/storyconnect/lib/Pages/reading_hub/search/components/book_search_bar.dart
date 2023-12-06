import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reading_hub/search/state/search_bloc.dart';

class BookSearchBar extends StatefulWidget {
  const BookSearchBar({super.key});

  @override
  State<StatefulWidget> createState() => BookSearchBarState();
}

class BookSearchBarState extends State<BookSearchBar> {
  late final TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 600, minWidth: 250, maxHeight: 75, minHeight: 75),
        child: Container(
            child: Row(children: [
          const DropdownMenu(
            menuHeight: 75,
            dropdownMenuEntries: [],
          ),
          Expanded(
              child: SearchBar(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0))),
                  controller: _textEditingController,
                  leading: const Icon(Icons.search),
                  hintText: 'Search',
                  onChanged: (search) {
                    context
                        .read<SearchBloc>()
                        .add(SearchChangedEvent(search: search));
                  },
                  trailing: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.x),
                  onPressed: () {
                    context.read<SearchBloc>().add(ClearStateEvent());
                    _textEditingController.clear();
                  },
                ),
              ])),
          SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    context.read<SearchBloc>().add(QueryEvent());
                  },
                  child: const Text("Search")))
        ])));
  }
}
