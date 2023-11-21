import 'package:flutter/material.dart';

typedef LabelBuilder<T> = String Function(T value);
typedef OnSelectedCallback<T> = void Function(T value);

class CustomDropdown<T> extends StatefulWidget {
  final T initialValue;
  final List<T> items;
  final LabelBuilder<T> labelBuilder;
  final String title;

  final OnSelectedCallback<T>? onSelected;

  const CustomDropdown({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.items,
    required this.labelBuilder,
    this.onSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late T currentValue;
  final List<DropdownMenuEntry<T>> items = [];

  @override
  void initState() {
    super.initState();

    for (T item in widget.items) {
      items.add(
        DropdownMenuEntry<T>(value: item, label: widget.labelBuilder(item)),
      );
    }

    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: currentValue,
      requestFocusOnTap: false,
      label: Text(widget.title),
      dropdownMenuEntries: items,
      onSelected: (T? newValue) {
        setState(() {
          if (newValue != null) {
            currentValue = newValue;
            if (widget.onSelected != null) {
              widget.onSelected!(newValue);
            }
          }
        });
      },
    );
  }
}
