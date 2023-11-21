import 'package:flutter/material.dart';

List<DropdownMenuEntry> entries = [];

class UserDropDownButton extends StatelessWidget {
  const UserDropDownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: entries,
    );
  }
}
