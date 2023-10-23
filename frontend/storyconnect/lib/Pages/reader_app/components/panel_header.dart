import 'package:flutter/material.dart';

class SidePopupHeader extends StatelessWidget {
  final String title;
  final VoidCallback dismiss;
  const SidePopupHeader(
      {super.key, required this.title, required this.dismiss});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        IconButton(
            onPressed: () {
              dismiss();
            },
            icon: Icon(Icons.close))
      ],
    );
  }
}