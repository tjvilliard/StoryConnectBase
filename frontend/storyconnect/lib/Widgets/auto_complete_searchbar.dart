import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/clickable.dart';

typedef AutocompleteSearchCallback = void Function(String value);

class AutoCompleteSearchBar extends StatefulWidget {
  final String? hintText;
  final List<String> searchableItems;
  final AutocompleteSearchCallback? searchCallback;
  const AutoCompleteSearchBar({super.key, this.hintText, required this.searchableItems, this.searchCallback});

  @override
  AutoCompleteSearchBarState createState() => AutoCompleteSearchBarState();
}

class AutoCompleteSearchBarState extends State<AutoCompleteSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static List<String> wordsToNotCapitalize = [
    "the",
    "a",
    "an",
    "and",
    "or",
    "but",
    "nor",
    "for",
    "so",
    "yet",
    "at",
    "by",
    "in",
    "of",
    "on",
    "to",
    "up",
    "as",
    "it",
    "is"
  ];

  String capitalizeTitle(String string) {
    final List<String> splitString = string.split(" ");
    for (int i = 0; i < splitString.length; i++) {
      if (!wordsToNotCapitalize.contains(splitString[i]) || i == 0) {
        splitString[i] = splitString[i][0].toUpperCase() + splitString[i].substring(1);
      }
    }
    return splitString.join(" ");
  }

  @override
  void initState() {
    super.initState();
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = isDarkMode(context);
    final Color searchBarColor = isDark ? theme.colorScheme.surfaceVariant : theme.colorScheme.surface;

    return Material(
        color: searchBarColor,
        elevation: 5,
        shape: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Leading Icon
              const Icon(Icons.search),
              const SizedBox(width: 10),

              // AutoComplete TextField
              Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return widget.searchableItems.where((String option) {
                      return option.startsWith(textEditingValue.text.toLowerCase().trim());
                    });
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: theme.textTheme.titleMedium,
                      onChanged: (String value) {
                        widget.searchCallback?.call(value);
                      },
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(color: theme.textTheme.labelMedium!.color),
                        border: InputBorder.none,
                      ),
                    );
                  },
                  optionsViewBuilder:
                      (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: Container(
                          color: theme.colorScheme.secondaryContainer,
                          width: 200,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              final formattedOption = capitalizeTitle(option);
                              return Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Clickable(
                                      onPressed: () {
                                        onSelected(option);
                                        widget.searchCallback?.call(capitalizeTitle(option));
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                          child: Text(
                                            formattedOption,
                                            style: Theme.of(context).textTheme.labelLarge,
                                          ))));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (String value) {
                    widget.searchCallback?.call(capitalizeTitle(value));
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
