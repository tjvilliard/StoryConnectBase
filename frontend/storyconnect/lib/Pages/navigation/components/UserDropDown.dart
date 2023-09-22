import 'package:flutter/material.dart';

List<DropdownMenuEntry> entries = [];

class UserDropDownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: entries,
    );
  }
}
