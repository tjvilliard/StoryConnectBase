import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/clickable.dart';

typedef AutocompleteSearchCallback = void Function(String value);

class AutoCompleteSearchBar extends StatefulWidget {
  final String? hintText;
  final List<String> searchableItems;
  final AutocompleteSearchCallback? searchCallback;
  const AutoCompleteSearchBar({super.key, this.hintText, required this.searchableItems, this.searchCallback});

  @override
  _AutoCompleteSearchBarState createState() => _AutoCompleteSearchBarState();
}

class _AutoCompleteSearchBarState extends State<AutoCompleteSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final List<String> searchableItems;

  @override
  void initState() {
    searchableItems = widget.searchableItems.map((String value) => value.toLowerCase().trim()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
        color: theme.colorScheme.secondaryContainer,
        elevation: 5,
        shape: StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Leading Icon
              Icon(Icons.search),
              const SizedBox(width: 10),

              // AutoComplete TextField
              Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return widget.searchableItems.where((String option) {
                      return option.contains(textEditingValue.text.toLowerCase().trim());
                    });
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: TextStyle(color: theme.textTheme.labelMedium!.color),
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
                          width: 200,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Clickable(
                                      onPressed: () {
                                        onSelected(option);
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                          child: Text(
                                            option,
                                            style: Theme.of(context).textTheme.labelLarge,
                                          ))));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (String value) {
                    widget.searchCallback?.call(value);
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
