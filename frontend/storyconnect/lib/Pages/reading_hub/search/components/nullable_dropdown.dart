import 'package:flutter/material.dart';

typedef LabelBuilder<T> = String Function(T value);
typedef OnSelectedCallback<T> = void Function(T value);

/// Dropdown menu widget with a default nullable state.
class NullableDropdown<T> extends StatefulWidget {
  final List<T> choices;
  final LabelBuilder<T?> labelBuilder;
  final String title;
  final OnSelectedCallback<T?> onSelected;

  const NullableDropdown({
    super.key,
    required this.choices,
    required this.labelBuilder,
    required this.title,
    required this.onSelected,
  });

  @override
  State<StatefulWidget> createState() => NullableDropdownState<T>();
}

class NullableDropdownState<T> extends State<NullableDropdown<T>> {
  late T? currentChoice;
  final List<DropdownMenuEntry<T?>> choices = [];

  @override
  void initState() {
    super.initState();
    choices.add(
        DropdownMenuEntry<T?>(value: null, label: widget.labelBuilder(null)));
    for (T? item in widget.choices) {
      choices.add(
          DropdownMenuEntry<T?>(value: item, label: widget.labelBuilder(item)));
    }

    currentChoice = null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T?>(
      dropdownMenuEntries: choices,
      initialSelection: currentChoice,
      requestFocusOnTap: false,
      label: Text(widget.title),
      onSelected: (T? choice) {
        setState(() {
          currentChoice = choice;
          widget.onSelected(choice);
        });
      },
    );
  }
}
