import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Constants/search_constants.dart';
import 'package:storyconnect/Pages/reading_hub/search/state/search_bloc.dart';

class BookSearchBar extends StatefulWidget {
  const BookSearchBar({super.key});

  @override
  State<StatefulWidget> createState() => BookSearchBarState();
}

class BookSearchBarState extends State<BookSearchBar> {
  static const double height = 60;
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
    final backgroundColorProperty =
        MaterialStateProperty.all<Color>(Colors.transparent);
    final surfaceTintColor =
        MaterialStateProperty.all<Color>(Colors.transparent);

    List<SearchModeConstant> choices = SearchModeConstant.values;

    return ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 600, minWidth: 250, maxHeight: height, minHeight: height),
        child: DecoratedBox(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: .4),
              borderRadius: BorderRadius.circular(0.4),
              shape: BoxShape.rectangle,
            ),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              DropdownMenu<SearchModeConstant>(
                initialSelection: SearchModeConstant.story,
                requestFocusOnTap: false,
                inputDecorationTheme:
                    Theme.of(context).inputDecorationTheme.copyWith(
                        border: InputBorder.none,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 16.0,
                        )),
                menuStyle: Theme.of(context).menuTheme.style?.copyWith(
                    surfaceTintColor: surfaceTintColor,
                    backgroundColor: backgroundColorProperty),
                dropdownMenuEntries: choices
                    .map((choice) => DropdownMenuEntry<SearchModeConstant>(
                        value: choice, label: choice.label))
                    .toList(),
                onSelected: (choice) {
                  context
                      .read<SearchBloc>()
                      .add(SearchModeChangedEvent(mode: choice!));
                },
              ),
              Expanded(
                  child: SearchBar(
                      shadowColor: const MaterialStatePropertyAll<Color>(
                          Colors.transparent),
                      surfaceTintColor: surfaceTintColor,
                      backgroundColor: backgroundColorProperty,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                      controller: _textEditingController,
                      hintText: 'Search',
                      onChanged: (search) {
                        context
                            .read<SearchBloc>()
                            .add(SearchChangedEvent(search: search));
                      },
                      trailing: [
                    Tooltip(
                        message: "Clear",
                        child: IconButton(
                          icon: const Icon(FontAwesomeIcons.x),
                          onPressed: () {
                            context.read<SearchBloc>().add(ClearSearchEvent());
                            _textEditingController.clear();
                          },
                        )),
                  ])),
              Tooltip(
                  message: "Search",
                  child: SizedBox(
                      width: height,
                      child: IconButton(
                          style: ButtonStyle(
                              shadowColor: backgroundColorProperty,
                              surfaceTintColor: surfaceTintColor,
                              backgroundColor: backgroundColorProperty,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(0.0)))),
                          onPressed: () {
                            context.read<SearchBloc>().add(QueryEvent());
                          },
                          icon: const Icon(FontAwesomeIcons.magnifyingGlass)))),
              Tooltip(
                  message: "Clear Result Entries",
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: backgroundColorProperty,
                          surfaceTintColor: surfaceTintColor,
                          backgroundColor: backgroundColorProperty,
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(0.0)))),
                      onPressed: () {
                        context.read<SearchBloc>().add(ClearResultsEvent());
                      },
                      child: const Text("Clear"))),
            ])));
  }
}
